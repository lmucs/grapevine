package cs.lmu.grapevine.adapters;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Filter;
import android.widget.Filterable;
import android.widget.TextView;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.sql.Date;
import cs.lmu.grapevine.entities.Event;
import cs.lmu.grapevine.R;

/**
 * Renders the views for the event feed from an ArrayList of events.
 */
public class EventFeedArrayAdapter extends ArrayAdapter<Event> implements Filterable {
    private ArrayList<Event> originalEvents;
    private ArrayList<Event> filteredItems;
    
    public EventFeedArrayAdapter(Context context, ArrayList<Event> events) {
        super(context, 0, events);
        this.originalEvents = new ArrayList<Event>(events);
        filteredItems = new ArrayList<>(events);
    }

    @Override
    public int getCount() {
        return filteredItems.size();
    }

    public Event getItem(int position) {
        return filteredItems.get(position);
    }

    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        Event event = filteredItems.get(position);

        //courtesy of https://github.com/codepath/android_guides/wiki/Using-an-ArrayAdapter-with-ListView
        // Check if an existing view is being reused, otherwise inflate the view
        if (convertView == null) {
            convertView = LayoutInflater.from(getContext()).inflate(R.layout.event_list_view, parent, false);
        }
        TextView eventTitleView = (TextView) convertView.findViewById(R.id.event_title);
        if (event.getTitle() == null) {
            eventTitleView.setText(R.string.untitled_event_title);
        } else {
            eventTitleView.setText(event.getTitle());
        }

        Date eventStartTime = new Date(event.getStartTimeTimestamp());
        Date eventEndTime   = new Date(event.getEndTimeTimestamp());
        SimpleDateFormat dateMonth = new SimpleDateFormat("LLL") ;
        SimpleDateFormat dateDay = new SimpleDateFormat("d");
        SimpleDateFormat timeOfEvent = new SimpleDateFormat("h:mm a");

        String eventTimeString =
                timeOfEvent.format(eventStartTime);
        if (event.endTimeIsKnown()) {
            eventTimeString += "-"
            +timeOfEvent.format(eventEndTime);
        }

        String monthString = dateMonth.format(eventStartTime);
        String dayString = dateDay.format(eventStartTime);

        ((TextView)convertView.findViewById(R.id.event_month)).setText(monthString);
        ((TextView)convertView.findViewById(R.id.event_day)).setText(dayString);
        ((TextView)convertView.findViewById(R.id.event_time)).setText(eventTimeString);

        return convertView;
    }

    @Override
    public Filter getFilter() {

        return new Filter() {
            @Override
            protected FilterResults performFiltering(CharSequence eventDayString) {

                FilterResults results = new FilterResults();
                ArrayList<Event> filteredEvents = new ArrayList<>();

                for (Event event : originalEvents){
                    java.util.Date dateOfEvent = new java.util.Date(event.getStartTimeTimestamp());
                    SimpleDateFormat stringDateFormat = new SimpleDateFormat("D");
                    String dateString = stringDateFormat.format(dateOfEvent);
                    if (dateString.equals(eventDayString)) {
                        filteredEvents.add(event);
                    }
                }

                results.values = filteredEvents;
                results.count  = filteredEvents.size();

                return results;
            }

            @Override
            protected void publishResults(CharSequence constraint, FilterResults results) {
                filteredItems = (ArrayList<Event>)results.values;
                notifyDataSetChanged();

            }
        };
    }

}
