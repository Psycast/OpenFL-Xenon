package classes.user;


import classes.user.User;
import com.flashfla.utils.ArrayUtil;

/**
	 * User Permissions
	 * Setups user permissions based on the users usergroups.
	 */
class UserPermissions
{
    //- Constants
    public static inline var ADMIN_ID : Float = 6;
    public static inline var BANNED_ID : Float = 8;
    public static inline var CHAT_MOD_ID : Float = 24;
    public static inline var FORUM_MOD_ID : Float = 5;
    public static inline var MULTI_MOD_ID : Float = 44;
    public static inline var MUSIC_PRODUCER_ID : Float = 46;
    public static inline var PROFILE_MOD_ID : Float = 56;
    public static inline var SIM_AUTHOR_ID : Float = 47;
    public static inline var VETERAN_ID : Float = 49;
    
    //- Variables
    public var isActiveUser : Bool;
    public var isGuest : Bool;
    public var isVeteran : Bool;
    public var isAdmin : Bool;
    public var isForumBanned : Bool;
    public var isGameBanned : Bool;
    public var isProfileBanned : Bool;
    public var isModerator : Bool;
    public var isForumModerator : Bool;
    public var isProfileModerator : Bool;
    public var isChatModerator : Bool;
    public var isMultiModerator : Bool;
    public var isMusician : Bool;
    public var isSimArtist : Bool;
    
    public function new(user : User = null)
    {
        if (user != null) 
        {
            setup(user);
        }
    }
    
    public function setup(user : User) : Void
    {
        this.isGuest = user.id <= 2;
        this.isVeteran = ArrayUtil.in_array(user.info.forum_groups, [VETERAN_ID]);
        this.isAdmin = ArrayUtil.in_array(user.info.forum_groups, [ADMIN_ID]);
        this.isForumBanned = ArrayUtil.in_array(user.info.forum_groups, [BANNED_ID]);
        this.isModerator = ArrayUtil.in_array(user.info.forum_groups, [ADMIN_ID, FORUM_MOD_ID, CHAT_MOD_ID, PROFILE_MOD_ID, MULTI_MOD_ID]);
        this.isForumModerator = ArrayUtil.in_array(user.info.forum_groups, [FORUM_MOD_ID, ADMIN_ID]);
        this.isProfileModerator = ArrayUtil.in_array(user.info.forum_groups, [PROFILE_MOD_ID, ADMIN_ID]);
        this.isChatModerator = ArrayUtil.in_array(user.info.forum_groups, [CHAT_MOD_ID, ADMIN_ID]);
        this.isMultiModerator = ArrayUtil.in_array(user.info.forum_groups, [MULTI_MOD_ID, ADMIN_ID]);
        this.isMusician = ArrayUtil.in_array(user.info.forum_groups, [MUSIC_PRODUCER_ID]);
        this.isSimArtist = ArrayUtil.in_array(user.info.forum_groups, [SIM_AUTHOR_ID]);
    }
}

