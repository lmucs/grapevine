package cs.lmu.grapevine.requests.listeners.success;

import android.app.Activity;
import android.view.View;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;
import android.widget.Toast;
import com.android.volley.Response;
import org.json.JSONObject;
import cs.lmu.grapevine.R;

/**
 * Created by
 * jeff on 11/21/15.
 */
public class FollowFeedSuccessListener implements Response.Listener<JSONObject> {
    private Activity parentActivity;

    @Override
    public void onResponse(JSONObject response) {
        stopProgressSpinner();
        toastSuccessMessage();
        parentActivity.finish();
    }

    public FollowFeedSuccessListener(Activity parentActivity) {
        this.parentActivity = parentActivity;
    }

    public void stopProgressSpinner(){
        parentActivity.findViewById(R.id.follow_feed_progress).setVisibility(View.INVISIBLE);
    }

    public void toastSuccessMessage() {
        TextView feedName =  (TextView)parentActivity.findViewById(R.id.feed_name);
        RadioGroup socialMediaGroup = (RadioGroup) parentActivity.findViewById(R.id.social_media_options);
        int feedRadioButtonId = socialMediaGroup.getCheckedRadioButtonId();
        String sourceName = (String)((RadioButton)parentActivity.findViewById(feedRadioButtonId)).getText();

        int duration = Toast.LENGTH_SHORT;
        String successString = "feed " + feedName.getText().toString() + " followed";
        Toast toast = Toast.makeText(parentActivity, successString, duration);
        toast.show();
    }
}
