package checkers.subCheckers;

/**
 * Class of the object returned by the check method
 */
public class Message {
    private boolean truthValue;
    private String message;

    public Message(boolean truthValue, String message){
        this.truthValue = truthValue;
        this.message = message;
    }

    public boolean getTruthValue() {
        return truthValue;
    }

    public String getMessage() {
        return message;
    }
}
