public class InfiniteLoop {
    public static void main(String[] args) {
        System.out.println("Starting infinite loop...");
        System.out.println("Process ID: " + ProcessHandle.current().pid());
        System.out.println("Press Ctrl+C to stop");
        
        long counter = 0;
        while (true) {
            counter++;
            
            // Print status every 1 million iterations
            if (counter % 1_000_000 == 0) {
                System.out.println("Iterations: " + counter);
            }
            
            // Small sleep to prevent excessive CPU usage
            try {
                Thread.sleep(1);
            } catch (InterruptedException e) {
                System.out.println("Loop interrupted");
                break;
            }
        }
    }
}
