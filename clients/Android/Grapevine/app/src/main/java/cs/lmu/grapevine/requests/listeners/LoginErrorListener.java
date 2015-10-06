package cs.lmu.grapevine.requests.listeners;

import android.app.Activity;
import android.widget.TextView;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import cs.lmu.grapevine.R;

/**
 * Listener for unsuccessful LoginRequests.
 */
public class LoginErrorListener implements Response.ErrorListener {
    private Activity parentActivity;

    public LoginErrorListener(Activity activity) {
        this.parentActivity = activity;
    }

    @Override
    public void onErrorResponse(VolleyError error) {
        TextView loginStatus = (TextView)parentActivity.findViewById(R.id.login_status);
        loginStatus.setText(R.string.login_error);

    }

}