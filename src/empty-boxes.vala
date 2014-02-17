// This file is part of GNOME Boxes. License: LGPLv2+

[GtkTemplate (ui = "/org/gnome/Boxes/ui/empty-boxes.ui")]
private class Boxes.EmptyBoxes : Gtk.Stack, Boxes.UI {
    public Clutter.Actor actor { get { return gtk_actor; } }
    public UIState previous_ui_state { get; protected set; }
    public UIState ui_state { get; protected set; }

    private GtkClutter.Actor gtk_actor;

    [GtkChild]
    private Gtk.Grid grid;

    public EmptyBoxes () {
        gtk_actor = new GtkClutter.Actor.with_contents (this);
        gtk_actor.get_widget ().get_style_context ().add_class ("boxes-bg");
        gtk_actor.opacity = 255;
        gtk_actor.x_align = Clutter.ActorAlign.FILL;
        gtk_actor.y_align = Clutter.ActorAlign.FILL;
        gtk_actor.x_expand = true;
        gtk_actor.y_expand = true;

        App.app.call_when_ready (on_app_ready);
    }

    private void on_app_ready () {
        update_visibility ();

        App.app.collection.item_added.connect (update_visibility);
        App.app.collection.item_removed.connect (update_visibility);
    }

    private void update_visibility () {
        var visible = ui_state == UIState.COLLECTION && App.app.collection.items.length == 0;
        if (visible != gtk_actor.visible)
            fade_actor (gtk_actor, visible? 255 : 0);

        if (visible && visible_child != grid)
            visible_child = grid;
    }
}
