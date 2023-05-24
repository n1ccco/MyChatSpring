package com.example.demo.model;

public class ChatMessage {
    public MessageType type;
    public String content;
    public String sender;

    public enum MessageType{
        CHAT,
        JOIN,
        LEAVE
    }
}
