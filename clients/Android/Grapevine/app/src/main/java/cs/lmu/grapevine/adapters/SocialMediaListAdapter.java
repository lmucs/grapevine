package cs.lmu.grapevine.adapters;

import android.app.Activity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;
import java.util.ArrayList;
import java.util.Collections;
import cs.lmu.grapevine.R;
import cs.lmu.grapevine.entities.SocialMediaFeed;
import cs.lmu.grapevine.Utils;

/**
 * Created by jeff on 12/4/15.
 */
public class SocialMediaListAdapter extends ArrayAdapter<SocialMediaFeed> {
    private ArrayList<SocialMediaFeed> usersFeeds;
    private Activity parentActivity;
    public SocialMediaListAdapter(Activity parentActivity, ArrayList<SocialMediaFeed> usersFeeds) {
        super(parentActivity, 0, usersFeeds);
        this.parentActivity = parentActivity;
        this.usersFeeds = usersFeeds;
    }

    @Override
    public int getCount() {
        return usersFeeds.size();
    }

    public SocialMediaFeed getItem(int position) {
        return usersFeeds.get(position);
    }

    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        SocialMediaFeed feed = usersFeeds.get(position);
        String feedName = feed.getName();
        String networkName = feed.getNetworkName();

        //courtesy of https://github.com/codepath/android_guides/wiki/Using-an-ArrayAdapter-with-ListView
        // Check if an existing view is being reused, otherwise inflate the view
        if (convertView == null) {
            convertView = LayoutInflater.from(getContext()).inflate(R.layout.social_media_list_view, parent, false);
        }
        TextView feedTitleView = (TextView) convertView.findViewById(R.id.feed_title);
        if (!(feedName == null)) {
            feedTitleView.setText(feedName);
        }

        if (!(networkName == null)) {
            ImageView brandIcon = (ImageView)convertView.findViewById(R.id.brand_icon);

            if (networkName.equals("twitter")){
                brandIcon.setImageBitmap(
                        Utils.decodeSampledBitmapFromResource(parentActivity.getResources(),
                                                              R.drawable.twitter_brand_logo,
                                                              100,
                                                              100
                        )
                );
            } else {
                brandIcon.setImageBitmap(Utils.decodeSampledBitmapFromResource(parentActivity.getResources(), R.drawable.facebook_brand_logo, 100, 100));
            }
        }

        return convertView;
    }

    @Override
    public void notifyDataSetChanged() {
        Collections.sort(usersFeeds);

        super.notifyDataSetChanged();
    }
}