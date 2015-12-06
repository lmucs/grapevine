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
import java.util.Calendar;
import java.util.Locale;

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

        if (event.getEventId() == 2252) {
            String here = "here";
        }

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

        TextView eventMonth = ((TextView)convertView.findViewById(R.id.event_month));
        TextView eventDay   = ((TextView)convertView.findViewById(R.id.event_day));
        TextView eventTime  = ((TextView)convertView.findViewById(R.id.event_time));
        TextView multiDay   = ((TextView)convertView.findViewById(R.id.multi_day));

        long nowTimestamp = Calendar.getInstance().getTimeInMillis();
        Date today = new Date(nowTimestamp);

        Date eventStartTime = new Date(event.getStartTimeTimestamp());
        Date eventEndTime   = new Date(event.getEndTimeTimestamp());

        SimpleDateFormat dateMonth = new SimpleDateFormat("LLL", Locale.ENGLISH) ;
        SimpleDateFormat dateDay = new SimpleDateFormat("d",Locale.ENGLISH);
        SimpleDateFormat timeOfEvent = new SimpleDateFormat("h:mm a",Locale.ENGLISH);
        SimpleDateFormat yearString = new SimpleDateFormat("yy",Locale.ENGLISH);
        SimpleDateFormat fullDate = new SimpleDateFormat("M/d/yyyy",Locale.ENGLISH);

        String startMonth = dateMonth.format(eventStartTime);
        String startDay = dateDay.format(eventStartTime);
        String startYear = yearString.format(eventStartTime);

        String endMonth = dateMonth.format(eventEndTime);
        String endDay = dateDay.format(eventEndTime);
        String endYear = yearString.format(eventEndTime);

        String todayMonth = dateMonth.format(today);
        String todayDay = dateDay.format(today);
        String todayYear = yearString.format(today);

        boolean eventStartsAndEndsSameDay = (startMonth.equals(endMonth))
                                          &&(startDay.equals(endDay))
                                          &&(startYear.equals(endYear));

        boolean todayStartDayAndEventNotStarted = (todayDay.equals(endDay))
                                                &&(todayMonth.equals(endMonth))
                                                &&(todayYear.equals(endYear))
                                                &&(nowTimestamp < event.getStartTimeTimestamp());

        boolean todayEndDay = (todayDay.equals(endDay))
                            &&(todayMonth.equals(endMonth))
                            &&(todayYear.equals(endYear));

        if (!(event.endTimeIsKnown())) {
            String eventTimeString = timeOfEvent.format(eventStartTime);

            eventMonth.setText(startMonth);
            eventDay.setText(startDay);
            eventTime.setText(eventTimeString);

        } else if (eventStartsAndEndsSameDay) {
            String eventTimeString =
                    timeOfEvent.format(eventStartTime)
                  + " - "
                  + timeOfEvent.format(eventEndTime);

            eventMonth.setText(startMonth);
            eventDay.setText(startDay);
            eventTime.setText(eventTimeString);

            multiDay.setVisibility(View.INVISIBLE);
        } else if (todayStartDayAndEventNotStarted) {
            String eventTimeString = "today at " + timeOfEvent.format(eventStartTime);
            eventMonth.setText(todayMonth);
            eventDay.setText(todayDay);
            eventTime.setText(eventTimeString);
            multiDay.setVisibility(View.VISIBLE);
        } else if (todayEndDay) {
            String eventTimeString = "ends today at " + timeOfEvent.format(eventEndTime);
            eventMonth.setText(endMonth);
            eventDay.setText(endDay);
            eventTime.setText(eventTimeString);
            multiDay.setVisibility(View.VISIBLE);
        } else if(eventStartTime.after(today)) {
            String eventTimeString = timeOfEvent.format(eventStartTime);

            eventMonth.setText(startMonth);
            eventDay.setText(startDay);
            eventTime.setText(eventTimeString);
            multiDay.setVisibility(View.VISIBLE);
        } else {
            //else - on event date and event already started, or on a day in between start and end dates.
            eventMonth.setText(todayMonth);
            eventDay.setText(todayDay);
            eventTime.setText("ends on "
                            + fullDate.format(eventEndTime));
            multiDay.setVisibility(View.VISIBLE);
        }

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