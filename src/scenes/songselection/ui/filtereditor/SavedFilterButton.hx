package scenes.songselection.ui.filtereditor;


import classes.engine.EngineCore;
import classes.engine.EngineLevelFilter;
import classes.ui.Box;
import classes.ui.BoxButton;
import classes.ui.Label;
import com.flashfla.utils.ArrayUtil;
import flash.display.DisplayObjectContainer;
import flash.events.Event;

class SavedFilterButton extends Box
{
    private var core : EngineCore;
    private var updater : FilterEditor;
    private var filter : EngineLevelFilter;
    public var filterName : Label;
    public var editButton : BoxButton;
    public var deleteButton : BoxButton;
    
    public function new(parent : DisplayObjectContainer, xpos : Float, ypos : Float, filter : EngineLevelFilter, updater : FilterEditor)
    {
        this.filter = filter;
        this.updater = updater;
        this.core = updater.core;
        super(parent, xpos, ypos);
    }
    
    override private function addChildren() : Void
    {
        filterName = new Label(this, 5, 0, filter.name);
        editButton = new BoxButton(this, 100, 0, core.getString("filter_editor_select_edit"), e_editClick);
        editButton.setSize(100, 23);
        deleteButton = new BoxButton(this, 200, 0, core.getString("filter_editor_delete"), e_deleteClick);
        deleteButton.setSize(100, 23);
    }
    
    override public function draw() : Void
    {
        super.draw();
        
        deleteButton.move(width - deleteButton.width - 5, 5);
        editButton.move(deleteButton.x - editButton.width - 5, 5);
        
        filterName.setSize(editButton.x - 10, height);
    }
    
    private function e_editClick(e : Event) : Void
    {
        core.variables.active_filter = filter;
        updater.DRAW_TAB = FilterEditor.TAB_FILTER;
        updater.draw();
    }
    
    private function e_deleteClick(e : Event) : Void
    {
        if (ArrayUtil.remove(filter, core.user.settings.filters)) 
            updater.draw();
    }
}
