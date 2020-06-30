package classes.user;


/**
	 * User Information Class
	 * Stores user specific information unique to FFR the Game.
	 */
class UserInfo
{
    public var hash : String;
    public var join_date : String;
    public var credits : Int;
    public var game_rank : Float;
    public var games_played : Int;
    public var grand_total : Int;
    public var songs_purchased : Array<Dynamic>;
    public var forum_groups : Array<Dynamic>;
    
    public function new(obj : Dynamic = null)
    {
        if (obj != null) 
        {
            setup(obj);
        }
    }
    
    public function setup(obj : Dynamic) : Void
    {
        // User Purchased Songs
        this.songs_purchased = [];
        if (Reflect.field(obj, "purchased")) 
        {
            for (x in 1...Reflect.field(obj, "purchased").length){
                this.songs_purchased.push(Reflect.field(obj, "purchased").charAt(x));
            }
        }  // Common Variables  
        
        
        
        this.hash = (Reflect.field(obj, "hash")) ? Reflect.field(obj, "hash") : "";
        this.credits = (Reflect.field(obj, "credits")) ? Reflect.field(obj, "credits") : 0;
        this.forum_groups = (Reflect.field(obj, "groups")) ? Reflect.field(obj, "groups") : [];
        this.join_date = (Reflect.field(obj, "joinDate")) ? Reflect.field(obj, "joinDate") : "";
        this.game_rank = (Reflect.field(obj, "gameRank")) ? Reflect.field(obj, "gameRank") : 0;
        this.games_played = (Reflect.field(obj, "gamesPlayed")) ? Reflect.field(obj, "gamesPlayed") : 0;
        this.grand_total = (Reflect.field(obj, "grandTotal")) ? Reflect.field(obj, "grandTotal") : 0;
    }
}

