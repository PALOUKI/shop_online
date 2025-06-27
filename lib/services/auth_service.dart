import '../models/user_model.dart';
import 'supabase_service.dart';

class AuthService {

  Future<bool> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      print('Tentative d\'inscription avec email: $email');


      final response = await SupabaseService.supabase.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );

      print('Réponse de signUp: ${response.user?.email}');
      print('Session: ${response.session?.accessToken != null ? 'Valide' : 'Invalide'}');

      if (response.user != null) {
        try {
          // Créer le profil utilisateur
          await SupabaseService.supabase.from('profiles').insert({
            'id': response.user!.id,
            'email': email,
            'full_name': fullName,
            'created_at': DateTime.now().toIso8601String(),
          });
          print('Profil créé avec succès');
          return true;
        } catch (e) {
          print('Erreur lors de la création du profil: $e');
          return false;
        }
      }
      return false;
    } catch (e) {
      print('=============================================');
      print('ERREUR DÉTAILLÉE D\'INSCRIPTION:');
      print('Type d\'erreur: ${e.runtimeType}');
      print('Message d\'erreur: $e');
      print('Stack trace: ${StackTrace.current}');
      print('=============================================');
      return false;
    }
  }

  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      print('Tentative de connexion avec email: $email');

      final response = await SupabaseService.supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      print('Réponse de signIn: ${response.user?.email}');
      print('Session: ${response.session?.accessToken != null ? 'Valide' : 'Invalide'}');

      if (response.user != null) {
        try {
          // Récupérer le profil utilisateur
          final profileData = await SupabaseService.supabase
              .from('profiles')
              .select()
              .eq('id', response.user!.id)
              .single();

          print('Profil récupéré: ${profileData['full_name']}');

          return UserModel(
            id: response.user!.id,
            email: email,
            fullName: profileData['full_name'],
          );
        } catch (e) {
          print('Erreur lors de la récupération du profil: $e');
          // Si le profil n'existe pas, on le crée
          await SupabaseService.supabase.from('profiles').insert({
            'id': response.user!.id,
            'email': email,
            'full_name': response.user!.userMetadata?['full_name'] ?? 'Utilisateur',
            'created_at': DateTime.now().toIso8601String(),
          });

          return UserModel(
            id: response.user!.id,
            email: email,
            fullName: response.user!.userMetadata?['full_name'] ?? 'Utilisateur',
          );
        }
      }
      return null;
    } catch (e) {
      print('Error signing in: $e');
      print('Stack trace: ${StackTrace.current}');
      return null;
    }
  }

  Future<void> signOut() async {
    await SupabaseService.supabase.auth.signOut();
  }

  UserModel? getCurrentUser() {
    final user = SupabaseService.supabase.auth.currentUser;
    if (user != null) {
      return UserModel(
        id: user.id,
        email: user.email!,
        fullName: user.userMetadata?['full_name'] ?? '',
      );
    }
    return null;
  }

  Future<bool> updateUserProfile(UserModel updatedUser) async {
    try {
      await SupabaseService.supabase.from('profiles').update({
        'full_name': updatedUser.fullName,
      }).eq('id', updatedUser.id);
      return true;
    } catch (e) {
      print('Error updating profile: $e');
      return false;
    }
  }
}
