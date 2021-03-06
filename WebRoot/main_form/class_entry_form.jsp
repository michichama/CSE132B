<html>

<body>
<h2>Class Entry Form</h2>
<table>
    <tr>
        <td valign="top">
            <%-- -------- Include menu HTML code -------- --%>
            <jsp:include page="/main_menu.html" />
        </td>
        <td>
            <%-- Import the java.sql package --%>
            <%@ page import="java.sql.*"%>
            <%-- -------- Open Connection Code -------- --%>
            <%

            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                // Registering Postgresql JDBC driver with the DriverManager
                Class.forName("org.postgresql.Driver");

                // Open a connection to the database using DriverManager
                conn = DriverManager.getConnection(
                    "jdbc:postgresql://localhost/cse132?" +
                    "user=postgres&password=wizard");
            %>

            <%-- -------- INSERT Code -------- --%>
            <%
                String action = request.getParameter("action");
                // Check if an insertion is requested
                if (action != null && action.equals("insert")) {

                    // Begin transaction
                    conn.setAutoCommit(false);

                    // Create the prepared statement and use it to
                    pstmt = conn
                    .prepareStatement("INSERT INTO class (title, course_id, year, quarter) VALUES (?, ?, ?, ?)");

                    pstmt.setString(1, request.getParameter("title"));
                    pstmt.setInt(2, Integer.parseInt(request.getParameter("course_id")));
                    pstmt.setInt(3, Integer.parseInt(request.getParameter("year")));
                    pstmt.setString(4, request.getParameter("quarter"));
                    int rowCount = pstmt.executeUpdate();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                }
            %>

            <%-- -------- UPDATE Code -------- --%>
            <%
                // Check if an update is requested
                if (action != null && action.equals("update")) {

                    // Begin transaction
                    conn.setAutoCommit(false);

                    pstmt = conn
                        .prepareStatement("UPDATE class SET title = ?, course_id = ?, year = ?, quarter = ? WHERE class_id = ? ");

                    pstmt.setString(1, request.getParameter("title"));
                    pstmt.setInt(2, Integer.parseInt(request.getParameter("course_id")));
                    pstmt.setInt(3, Integer.parseInt(request.getParameter("year")));
                    pstmt.setString(4, request.getParameter("quarter"));
                    pstmt.setInt(5, Integer.parseInt(request.getParameter("class_id")));

                    int rowCount = pstmt.executeUpdate();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                }
            %>

            <%-- -------- DELETE Code -------- --%>
            <%
                // Check if a delete is requested
                if (action != null && action.equals("delete")) {

                    // Begin transaction
                    conn.setAutoCommit(false);

                    // Create the prepared statement and use it to
                    // DELETE students FROM the Students table.
                    pstmt = conn
                        .prepareStatement("DELETE FROM class WHERE class_id = ?");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("class_id")));
                    int rowCount = pstmt.executeUpdate();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                }
            %>

            <%-- -------- SELECT Statement Code -------- --%>
            <%
                // Create the statement
                Statement statement = conn.createStatement();

                // Use the created statement to SELECT
                rs = statement.executeQuery("SELECT * FROM class cl, course co WHERE cl.course_id = co.course_id ORDER BY class_id");
            %>

            <h4>Insert</h4>
            <!-- Add an HTML table header row to format the results -->
            <table border="1">
            <tr>
                <th>ID</th>
                <th>Title</th>
                <th>Course Id</th>
                <th>Year</th>
                <th>Quarter</th>
            </tr>

            <tr>
                <form action="class_entry_form.jsp" method="POST">
                    <input type="hidden" name="action" value="insert"/>
                    <th>&nbsp;</th>
                    <th><input value="" name="title" size="15"/></th>
                    <th><input value="" name="course_id" size="15"/></th>
                    <th><input value="" name="year" size="15"/></th>
                    <th>
                      <select name="quarter">
                        <option value="SPRING">SPRING</option>
                        <option value="SUMMER">SUMMER</option>
                        <option value="FALL">FALL</option>
                        <option value="WINTER">WINTER</option>
                      </select>
                    </th>
                    <th><input type="submit" value="Insert"/></th>
                </form>
            </tr>

            </table>
            <hr>
            <h4>Modify</h4>
            <table border="1">
            <tr>
                <th>ID</th>
                <th>Title</th>
                <th>Course Id</th>
                <th>Year</th>
                <th>Quarter</th>
                <th>Course Number</th>
            </tr>
            <%-- -------- Iteration Code -------- --%>
            <%
                // Iterate over the ResultSet
                while (rs.next()) {
            %>

            <tr>
                <form action="class_entry_form.jsp" method="POST">
                    <input type="hidden" name="action" value="update"/>
                    <input type="hidden" name="class_id" value="<%=rs.getInt("class_id")%>"/>

                <td>
                    <%=rs.getInt("class_id")%>
                </td>

                <td>
                    <input value="<%=rs.getString("title")%>" name="title" size="15"/>
                </td>

                <td>
                    <input value="<%=rs.getInt("course_id")%>" name="course_id" size="15"/>
                </td>

                <td>
                    <input value="<%=rs.getInt("year")%>" name="year" size="15"/>
                </td>

                <td>
                    <input value="<%=rs.getString("quarter")%>" name="quarter" size="15"/>
                </td>

                <td>
                    <%=rs.getString("course_number")%>
                </td>

                <%-- Button --%>
                <td><input type="submit" value="Update"></td>
                </form>
                <form action="class_entry_form.jsp" method="POST">
                    <input type="hidden" name="action" value="delete"/>
                    <input type="hidden" name="class_id" value="<%=rs.getInt("class_id")%>"/>
                    <%-- Button --%>
                <td><input type="submit" value="Delete"/></td>
                </form>
            </tr>
            <%
                }
            %>

            <%-- -------- Close Connection Code -------- --%>
            <%
                // Close the ResultSet
                rs.close();

                // Close the Statement
                statement.close();

                // Close the Connection
                conn.close();
            } catch (SQLException e) {

                // Wrap the SQL exception in a runtime exception to propagate
                // it upwards
                throw new RuntimeException(e);
            }
            finally {
                // Release resources in a finally block in reverse-order of
                // their creation

                if (rs != null) {
                    try {
                        rs.close();
                    } catch (SQLException e) { } // Ignore
                    rs = null;
                }
                if (pstmt != null) {
                    try {
                        pstmt.close();
                    } catch (SQLException e) { } // Ignore
                    pstmt = null;
                }
                if (conn != null) {
                    try {
                        conn.close();
                    } catch (SQLException e) { } // Ignore
                    conn = null;
                }
            }
            %>
        </table>
        </td>
    </tr>
</table>
</body>

</html>
