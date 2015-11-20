package cs.lmu.grapevine.requests;

import android.app.Activity;
import android.view.View;
import android.widget.ProgressBar;
import com.android.volley.toolbox.JsonObjectRequest;
import cs.lmu.grapevine.BuildConfig;
import cs.lmu.grapevine.R;
import cs.lmu.grapevine.requests.listeners.error.LoginErrorListener;
import cs.lmu.grapevine.requests.listeners.success.LoginSuccessListener;

/**
 * Un-authenticated request for logging in to Grapevine.
 */
public class LoginRequest extends JsonObjectRequest {
    private static String loginUrl = BuildConfig.API_HOST + "tokens";
    private Activity parentActivity;

    public LoginRequest(Activity parentActivity, String requestBodyString) {
        super(Method.POST,
                loginUrl,
                RequestHelper.serializeRequestBody(requestBodyString),
                new LoginSuccessListener(parentActivity),
                new LoginErrorListener(parentActivity)
        );
        this.parentActivity = parentActivity;
        showLoginSpinner();
    }

    private void showLoginSpinner() {
        ProgressBar loginProgress = (ProgressBar)parentActivity.findViewById(R.id.login_progress);
        loginProgress.setVisibility(View.VISIBLE);
    }

}