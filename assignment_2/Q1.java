import java.util.*;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.lang.Math;

public class Q1 {

    static HashMap<String, Integer> map = new HashMap<>();

    static ArrayList<String> makeSubsets(String set[]) {
        ArrayList<String> subsets = new ArrayList<String>();
        int n = set.length;

        for (int i = 1; i < (1 << n); i++) {
            StringBuilder subset = new StringBuilder();
            for (int j = 0; j < n; j++) {
                // (1<<j) is a number with jth bit 1
                // so when we 'and' them with the
                // subset number we get which numbers
                // are present in the subset and which
                // are not
                if ((i & (1 << j)) > 0) {
                    subset.append(set[j] + ' ');
                }
            }
            subsets.add(subset.toString().trim());
        }
        return subsets;
    }

    static ArrayList<String> makeSubsets_proper(String set[]) {
        ArrayList<String> subsets = new ArrayList<String>();
        int n = set.length;

        for (int i = 1; i < (1 << n) - 1; i++) {
            StringBuilder subset = new StringBuilder();
            for (int j = 0; j < n; j++) {
                if ((i & (1 << j)) > 0) {
                    subset.append(set[j] + ' ');
                }
            }
            subsets.add(subset.toString().trim());
        }
        return subsets;
    }

    static ArrayList<String> findSuperKeys(ArrayList<String> subsets, String[][] dataArray) {
        ArrayList<String> sk = new ArrayList<String>();
        for (int i = 0; i < subsets.size(); i++) {
            String key = subsets.get(i);
            if (uniquelyIdentifies(key, dataArray))
                sk.add(key);
        }
        return sk;
    }

    static boolean uniquelyIdentifies(String key, String[][] dataArray) {
        String[] a = key.split(" ");
        int[] tmp = new int[a.length];
        for (int i = 0; i < a.length; i++) {
            tmp[i] = map.get(a[i]);
        }

        HashSet<String> set = new HashSet<>();

        for (int i = 1; i <= 5; i++) {
            StringBuilder row = new StringBuilder();
            for (int j = 0; j < tmp.length; j++) {
                row.append(dataArray[i][tmp[j]]).append(" ");
            }
            set.add(row.toString().trim());
        }
        return set.size() == 5;
    }

    private static String[][] readDataFromFile(String filePath) {
        String[][] dataArray = null;

        try {
            Scanner scanner = new Scanner(new File(filePath));

            int rows = 0;
            int cols = 0;
            while (scanner.hasNextLine()) {
                rows++;
                String line = scanner.nextLine();
                String[] values = line.split(", ");
                cols = Math.max(cols, values.length);
            }

            scanner.close();
            scanner = new Scanner(new File(filePath));

            dataArray = new String[rows][cols];

            // Populate the 2D array
            for (int i = 0; i < rows; i++) {
                String line = scanner.nextLine();
                String[] values = line.split(", ");
                for (int j = 0; j < values.length; j++) {
                    dataArray[i][j] = values[j];
                }
            }
            scanner.close();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        return dataArray;
    }

    static ArrayList<String> findCandidateKeys(ArrayList<String> superKeys) {
        ArrayList<String> ck = new ArrayList<String>();
        for (String key : superKeys) {
            String[] split = key.split(" ");
            ArrayList<String> subgroups = makeSubsets_proper(split);
            boolean flag = true;
            for (String s : subgroups) {
                if (isSuperKey(s, superKeys)) {
                    flag = false;
                }
            }
            if (flag) {
                ck.add(key);
            }
        }
        return ck;
    }

    static boolean isSuperKey(String key, ArrayList<String> superKeys) {
        for (int i = 0; i < superKeys.size(); i++) {
            if (key.equals(superKeys.get(i)))
                return true;
        }
        return false;
    }
    public static void main(String[] args) throws IOException {
        String filePath = "Keys.txt";
        BufferedReader reader = new BufferedReader(new FileReader(filePath));
        String line = reader.readLine();
        String[] attributes = line.split(", ");
        for (int i = 0; i < attributes.length; i++)
            map.put(attributes[i], i);

        ArrayList<String> subsets = makeSubsets(attributes);
        System.out.println(subsets);

        String[][] dataArray = readDataFromFile(filePath);

        // Finding super keys
        ArrayList<String> superKeys = findSuperKeys(subsets, dataArray);
        System.out.println("Super Keys: " + superKeys);

        // Finding candidate keys
        ArrayList<String> candidateKeysRecursive = findCandidateKeys(superKeys);
        System.out.println("Candidate Keys: " + candidateKeysRecursive);
        reader.close();
    }
}