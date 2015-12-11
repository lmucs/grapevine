package cs.lmu.grapevine.listeners;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.view.View;
import android.widget.AdapterView;
import cs.lmu.grapevine.R;
import cs.lmu.grapevine.activities.Login;
import cs.lmu.grapevine.entities.SocialMediaFeed;
import cs.lmu.grapevine.requests.UnfollowFeedRequest;

/**
 * Created by jeff on 12/5/15.
 */
public class SocialMediaFeedClickListener implements AdapterView.OnItemLongClickListener {
    private Activity parentActivity;

    public SocialMediaFeedClickListener(Activity parentActivity) {
        this.parentActivity = parentActivity;
    }

    @Override
    public boolean onItemLongClick(AdapterView<?> parent, View view, int position, long id) {
        SocialMediaFeed feedSelected = (SocialMediaFeed)parent.getItemAtPosition(position);

        expandSocialMediaFeedDialog(feedSelected);

        return true;
    }

    private void expandSocialMediaFeedDialog(final SocialMediaFeed selectedFeed) {
        AlertDialog.Builder builder = new AlertDialog.Builder(parentActivity);
            // Add the buttons
        builder.setPositiveButton(R.string.unfollow_feed, new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int id) {
            UnfollowFeedRequest unfollowFeed = new UnfollowFeedRequest(parentActivity,
                                                                       selectedFeed.getNetworkName(),
                                                                       selectedFeed.getName());
            Login.httpRequestQueue.add(unfollowFeed);
            }
        });

        builder.setTitle("Unfollow?");
        builder.setMessage(selectedFeed.getName());

        builder.setNegativeButton(R.string.cancel, new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int id) {
                // User cancelled the dialog
            }
        });

        // Create the AlertDialog
        AlertDialog dialog = builder.create();
        dialog.show();
    }
}