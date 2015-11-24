package cs.lmu.grapevine.activities;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;
import cs.lmu.grapevine.R;
import cs.lmu.grapevine.requests.FollowFeedRequest;

public class FollowFeed extends AppCompatActivity {
    private EditText   feedNameEditText;
    private RadioGroup feedSources;
    private Button     addFeedButton;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.follow_feed);

        grabReferencesToEditTextAndButton();
        addListenerToTextView();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_add_group, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    public void addGroupIfValid(View view) {
        RadioGroup socialMediaGroup = (RadioGroup) findViewById(R.id.social_media_options);
        TextView groupNameTextView = (TextView) findViewById(R.id.feed_name);

        int feedRadioButtonId = socialMediaGroup.getCheckedRadioButtonId();
        String feedName = groupNameTextView.getText().toString();

        String sourceName = (String)((RadioButton)findViewById(feedRadioButtonId)).getText();

        if (!(feedName.equals(""))) {
            String requestBodyString =
                    "{\"feedName\":\""
                            + feedName
                            + "\",\"networkName\":\""
                            + sourceName
                            + "\"}";

            FollowFeedRequest followGroupRequest = new FollowFeedRequest(this, requestBodyString);
            Login.httpRequestQueue.add(followGroupRequest);
        }
    }

    public void addListenerToTextView() {

        feedNameEditText.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                checkInputsAndToggleButton();
            }

            @Override
            public void afterTextChanged(Editable s) {

            }
        });
    }

    public void toggleButtonIfInputsValid(View view){
        checkInputsAndToggleButton();
    }

    public void checkInputsAndToggleButton(){
        if (!feedNameEditText.getText().toString().trim().equals("") && feedSources.getCheckedRadioButtonId() != -1) {
            addFeedButton.setEnabled(true);
        } else {
            addFeedButton.setEnabled(false);
        }
    }

    private void grabReferencesToEditTextAndButton() {
        feedNameEditText = (EditText)findViewById(R.id.feed_name);
        addFeedButton = (Button)findViewById(R.id.add_feed_button);
        feedSources = (RadioGroup)findViewById(R.id.social_media_options);
    }

}
