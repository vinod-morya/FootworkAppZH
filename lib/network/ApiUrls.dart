const String baseUrl = 'http://www.nbafootwork.cn/api/';
// ****************** login Api **************** //
//const String loginUrl = 'user/generate_auth_cookie';
const String loginUrl = 'user/generate_auth_cookie';
const String notificationApi = 'user/notification_status';

//****************** Reset Password Api **************** //
const String forgetPasswordUrl = 'user/retrieve_password';

//****************** User Registration Api **************** //
const String getUserCurrentInfo = 'user/get_currentuserinfo';
const String getNonceKey = 'get_nonce?controller=user&method=register';
const String register = 'user/register';

//****************** Validate Auth key Api **************** //
const String validateAuth = 'user/validate_auth_cookie';

//*******************UserDashBoard Api**************************//
const String apiDashBoard = 'user/user_dashboard';

//*******************VideoList Api**************************//
const String apiVideoListMonthWise = 'user/get_user_videos';

//*******************SetFavouriteVideo Api**************************//
const String apiSetFavourite = 'user/set_favorite_video';

//******************* Update Profile Api**************************//
const String updateProfile = 'user/update_user_meta_vars';

//******************* Change Password Api**************************//
const String changePassApiUrl = 'user/change_password';

//******************* setVideoStatus Api**************************//
const String setVideoStatus = 'user/set_video_play_status';

//******************* getFavouriteVideo Api**************************//
const String getFavouriteVideo = 'user/get_user_custom_video_list';

//******************* addComment Api**************************//
const String addCommentApi = 'user/add_comment';

//******************* get State & Countries Api**************************//
const String getCountries = 'user/get_countries';
const String getStateList = 'user/get_state_by_country';

//*******************Logout Api**************************//
const String apiLogout = 'user/logout';
const String apiInviteUser = 'user/invite_users';

//*******************Stripe Api**************************//
const String createStripeSource = 'user/stripe_create_source';
const String authorizeAccount = 'user/authorized_account';
const String updatePurchase = 'user/footwork_month_purchase';
