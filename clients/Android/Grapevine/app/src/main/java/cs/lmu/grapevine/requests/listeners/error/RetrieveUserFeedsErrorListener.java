package cs.lmu.grapevine.requests.listeners.error;

import android.app.Activity;
import com.android.volley.Response;
import com.android.volley.VolleyError;

/**
 * Created by jeff on 12/4/15.
 */
public class RetrieveUserFeedsErrorListener implements Response.ErrorListener {
    private Activity parentActivity;

    public RetrieveUserFeedsErrorListener(Activity parentActivity) {
        this.parentActivity = parentActivity;
    }

    @Override
    public void onErrorResponse(VolleyError error) {

    }
}
