import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

// Compile using javac -cp C:\Users\Asus\MySqlJdbcDriver\mysql-connector-j-8.3.0.jar AS7.java

public class AS7 {

    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/as3";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "password";

    public static void main(String[] args) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection connection = DriverManager.getConnection(JDBC_URL, USERNAME, PASSWORD);
            Statement statement = connection.createStatement();

            // Question 1
            executeQuery(statement, "SELECT DISTINCT(fname) FROM faculty");

            // Question 2
            executeQuery(statement, "SELECT DISTINCT(dname) FROM department");

            // Question 3
            executeQuery(statement, "SELECT fname FROM faculty AS f, teaches AS t WHERE f.fid = t.fid AND t.cid = 1");

            // Question 4
            executeQuery(statement, "SELECT sname FROM student AS s, takes AS t WHERE s.sid = t.sid GROUP BY sname");

            // Question 5
            executeQuery(statement, "SELECT sname FROM student AS s, takes AS t WHERE s.sid = t.sid GROUP BY sname HAVING COUNT(cid) > 1");

            // Question 6
            executeQuery(statement, "SELECT sname FROM student AS s, takes AS t WHERE s.sid = t.sid GROUP BY sname HAVING COUNT(cid) = 3");

            // Question 7
            executeQuery(statement, "SELECT sname FROM student AS s WHERE s.sid NOT IN (SELECT takes.sid FROM takes)");

            // Question 8
            executeQuery(statement, "SELECT * FROM department WHERE budget = (SELECT MAX(budget) FROM department)");

            // Question 9
            executeQuery(statement, "WITH fac_count (fid, fname, course_count) " +
                                     "AS (SELECT t.fid, f.fname, count(cid) " +
                                     "FROM teaches AS t, faculty AS f WHERE f.fid = t.fid " +
                                     "GROUP BY fid ORDER BY count(cid) ASC) " +
                                     "SELECT fname FROM fac_count WHERE course_count = (SELECT MAX(course_count) FROM fac_count)");

            // Question 10
            executeQuery(statement, "WITH tab (building, dept_count) " +
                                     "AS (SELECT building, count(dname) " +
                                     "FROM department " +
                                     "GROUP BY building " +
                                     "ORDER BY COUNT(dname) ASC) " +
                                     "SELECT building FROM tab WHERE dept_count = (SELECT MAX(dept_count) FROM tab)");

            statement.close();
            connection.close();

        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
    }

    private static void executeQuery(Statement statement, String query) throws SQLException {
        ResultSet resultSet = statement.executeQuery(query);
        System.out.println("Query: " + query);
        System.out.println("Results:");
        while (resultSet.next()) {
            System.out.println(resultSet.getString(1));
        }
        System.out.println("--------------------------");
    }
}
