package com.boot.DTO;

import lombok.Data;

@Data
public class SNSFollowDTO {
    private String loginEmail;
    private String followEmail;
    private int followUserType;
    private int followerCount;
    private int followingCount;
    private String follow_name;
    private String userName;
    private String userType;
}
