package cs.lmu.grapevine.entities;

import com.google.gson.annotations.SerializedName;

/**
 * Created by jeff on 12/4/15.
 */
public class SocialMediaFeed implements Comparable<SocialMediaFeed> {
    @SerializedName("feed_name")
    private String name;
    @SerializedName("network_name")
    private String networkName;

    public String getName() {
        return name;
    }

    public void setName(String feedName) {
        this.name = feedName;
    }

    public String getNetworkName() {
        return networkName;
    }

    public void setNetworkName(String networkName) {
        this.networkName = networkName;
    }

    public SocialMediaFeed() {

    }

    @Override
    public int compareTo(SocialMediaFeed another) {
        if (another == null) {
            throw new IllegalArgumentException();
        }

        return name.toLowerCase().compareTo(another.getName().toLowerCase());
    }
}
