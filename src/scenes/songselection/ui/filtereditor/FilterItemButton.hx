package scenes.songselection.ui.filtereditor;


import classes.engine.EngineCore;
import classes.engine.EngineLevelFilter;
import classes.ui.Box;
import classes.ui.BoxButton;
import classes.ui.BoxCombo;
import classes.ui.BoxInput;
import classes.ui.Label;
import com.flashfla.utils.ArrayUtil;
import flash.display.DisplayObjectContainer;
import flash.events.Event;

class FilterItemButton extends Box
{
    private var core : EngineCore;
    private var updater : FilterEditor;
    private var filter : EngineLevelFilter;
    
    private var filterIcon : FilterIcon;
    private var combo_stat : BoxCombo;
    private var input_box : BoxInput;
    private var combo_compare : BoxCombo;
    private var remove_button : BoxButton;
    
    public function new(parent : DisplayObjectContainer, xpos : Float, ypos : Float, filter : EngineLevelFilter, updater : FilterEditor)
    {
        this.filter = filter;
        this.updater = updater;
        this.core = updater.core;
        super(parent, xpos, ypos);
    }
    
    override private function init() : Void
    {
        setSize(327, 33, false);
        addChildren();
        draw();
    }
    
    override private function addChildren() : Void
    {
        remove_button = new BoxButton(this, width, 0, "X", e_clickRemovefilter);
        remove_button.setSize(23, height);
        
        //filterIcon = new FilterIcon(this, 5, 6, filter.type, false);
        //filterIcon.setSize(23, 23);
        
        var _sw1_ = (filter.type);        

        switch (_sw1_)
        {
            case EngineLevelFilter.FILTER_STATS:
                combo_stat = new BoxCombo(core, this, 5, 5, filter.input_stat, e_valueStatChange);
                combo_stat.options = EngineLevelFilter.createOptions(core, EngineLevelFilter.FILTERS_STAT, "compare_stat");
                combo_stat.title = core.getString("filter_editor_comparison");
                combo_stat.selectedIndex = filter.input_stat;
                combo_stat.setSize(120, 23);  // 90  
                
                combo_compare = new BoxCombo(core, this, 130, 5, filter.comparison, e_valueCompareChange);
                combo_compare.options = BoxCombo.fromStringArray(EngineLevelFilter.FILTERS_NUMBER);
                combo_compare.title = core.getString("filter_editor_comparison");
                combo_compare.selectedIndex = filter.comparison;
                combo_compare.setSize(80, 23);
                
                input_box = new BoxInput(this, 215, 5, Std.string(filter.input_number), e_valueNumberChange);
                input_box.setSize(107, 23);
				
            case EngineLevelFilter.FILTER_ARROWCOUNT, 
					EngineLevelFilter.FILTER_BPM, 
					EngineLevelFilter.FILTER_DIFFICULTY, 
					EngineLevelFilter.FILTER_MAX_NPS, 
					EngineLevelFilter.FILTER_MIN_NPS, 
					EngineLevelFilter.FILTER_RANK, 
					EngineLevelFilter.FILTER_SCORE, 
					EngineLevelFilter.FILTER_TIME:
                new Label(this, 5, 6, core.getString("filter_type_" + filter.type));
                
                combo_compare = new BoxCombo(core, this, 100, 5, filter.comparison, e_valueCompareChange);
                combo_compare.options = BoxCombo.fromStringArray(EngineLevelFilter.FILTERS_NUMBER);
                combo_compare.title = core.getString("filter_editor_comparison");
                combo_compare.selectedIndex = filter.comparison;
                combo_compare.setSize(110, 23);
                
                input_box = new BoxInput(this, 215, 5, Std.string(filter.input_number), e_valueNumberChange);
                input_box.setSize(107, 23);
				
            case EngineLevelFilter.FILTER_ID, 
					EngineLevelFilter.FILTER_NAME, 
					EngineLevelFilter.FILTER_STYLE, 
					EngineLevelFilter.FILTER_ARTIST, 
					EngineLevelFilter.FILTER_STEPARTIST:
                new Label(this, 5, 6, core.getString("filter_type_" + filter.type));
                
                combo_compare = new BoxCombo(core, this, 100, 5, filter.comparison, e_valueCompareChange);
                combo_compare.options = EngineLevelFilter.createOptions(core, EngineLevelFilter.FILTERS_STRING, "compare_string");
                combo_compare.title = core.getString("filter_editor_comparison");
                combo_compare.selectedIndex = filter.comparison;
                combo_compare.setSize(110, 23);
                
                input_box = new BoxInput(this, 215, 5, filter.input_string, e_valueStringChange);
                input_box.setSize(107, 23);
            
            default:
                new Label(this, 5, 6, filter.type);
        }
    }
    
    private function e_valueCompareChange(e : Dynamic) : Void
    {
        filter.comparison = Reflect.field(e, "value");
    }
    
    private function e_valueStatChange(e : Dynamic) : Void
    {
        filter.input_stat = Reflect.field(e, "value");
    }
    
    private function e_valueStringChange(e : Event) : Void
    {
        filter.input_string = input_box.text;
    }
    
    private function e_valueNumberChange(e : Event) : Void
    {
        var newNumber : Float = Std.parseFloat(input_box.text);
        if (Math.isNaN(newNumber)) 
            newNumber = 0;
        filter.input_number = newNumber;
    }
    
    private function e_clickRemovefilter(e : Event) : Void
    {
        if (ArrayUtil.remove(filter, filter.parent_filter.filters)) 
            updater.draw();
    }
}

