/**
 * The EventManager is the class that manage all the operations concerning the events.
 * In this case is handled the add event operation. 
 *
 * ActionParameter is the abstract class that all the check operation's parameters extend
 */
public class EventsManager {

    public String addEvent(ActionParameters eventInfo){
        CheckerInterface operationChecker = new AddEventChecker();
        RepositoryManager repositoryManager = new RepositoryManager();

        Message result = operationChecker.check(eventInfo);
        if (result.getTruthValue())
            return repositoryManager.addEvent(eventInfo);
        else
            return result.getMessage();
    }
}