Imports System.Data.SqlClient
Imports System.Data
Imports System.Configuration
Imports Newtonsoft.Json
Imports System.Web.Services
Imports System.Linq.Expressions
Imports System.Exception

Public Class Values
    Public Property UserRole As String
    Public Property UserName As String
    Public Property UserRDesc As String
End Class

Public Class User_Role_Management
    Inherits System.Web.UI.Page
    Public Shared connectionString As String = ConfigurationManager.ConnectionStrings("mytable").ConnectionString
    Public d As SqlDataReader
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub
    'Get Method Loading a data in DataTable from SQLDataBase'
    <WebMethod>
    Public Shared Function GetData()
        Dim query As String = "select ID,User_Role_Desc,USER_ROLE_NAME, USER_ROLE_TEXT,Status from MDT_User_Role_Master"
        Dim conn As SqlConnection = New SqlConnection(connectionString)
        Dim da As SqlDataAdapter = New SqlDataAdapter(query, conn)
        Dim dt As DataTable = New DataTable()
        da.Fill(dt)
        Dim data As List(Of Dictionary(Of String, Object)) = New List(Of Dictionary(Of String, Object))()
        For Each row As DataRow In dt.Rows
            Dim dict As Dictionary(Of String, Object) = New Dictionary(Of String, Object)()
            For Each col As DataColumn In dt.Columns
                dict(col.ColumnName) = row(col)
            Next
            data.Add(dict)
        Next
        Return JsonConvert.SerializeObject(data)

    End Function

    <WebMethod>
    Public Shared Function InsertData(datas As Values) As String
        Try
            Dim conn As SqlConnection = New SqlConnection(connectionString)
            Dim query As String = "INSERT INTO MDT_User_Role_Master (User_Role_Desc,USER_ROLE_NAME,USER_ROLE_TEXT) VALUES (@userrole, @Userrolename, @Userroletext)"
            Dim cmd As SqlCommand = New SqlCommand(query, conn)
            cmd.Parameters.AddWithValue("@userrole", datas.UserRole)
            cmd.Parameters.AddWithValue("@Userrolename", datas.UserName)
            cmd.Parameters.AddWithValue("@Userroletext", datas.UserRDesc)
            conn.Open()
            cmd.ExecuteNonQuery()
        Catch ex As Exception
            Console.WriteLine(ex.Message)
        End Try
        Return "Data Insert Successfully"
    End Function


    <WebMethod>
    Public Shared Function Active_Status() As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("mytable").ConnectionString
        Dim query As String = "SELECT ID, User_Role_Desc, USER_ROLE_NAME, USER_ROLE_TEXT, Status FROM MDT_User_Role_Master WHERE Status = 1"

        Dim data As New List(Of Dictionary(Of String, Object))()

        Using conn As New SqlConnection(connectionString)
            Try
                conn.Open()
                Dim da As New SqlDataAdapter(query, conn)
                Dim dt As New DataTable()
                da.Fill(dt)

                For Each row As DataRow In dt.Rows
                    Dim dict As New Dictionary(Of String, Object)()
                    For Each col As DataColumn In dt.Columns
                        dict(col.ColumnName) = row(col)
                    Next
                    data.Add(dict)
                Next

            Catch ex As Exception
                Throw New Exception("An error occurred while fetching data.", ex)
            End Try
        End Using

        Return JsonConvert.SerializeObject(data)
    End Function

    <WebMethod()>
    Public Shared Function InActive_Status() As String
        Dim conn As New SqlConnection(connectionString)
        Dim query As String = "SELECT ID, User_Role_Desc, USER_ROLE_NAME, USER_ROLE_TEXT, Status FROM MDT_User_Role_Master WHERE Status = 0"
        Dim da As New SqlDataAdapter(query, conn)
        Dim dt As New DataTable()
        da.Fill(dt)
        Dim data As New List(Of Dictionary(Of String, Object))()
        For Each row As DataRow In dt.Rows
            Dim dict As New Dictionary(Of String, Object)()
            For Each col As DataColumn In dt.Columns
                dict(col.ColumnName) = row(col)
            Next
            data.Add(dict)
        Next
        Return JsonConvert.SerializeObject(data)
    End Function

    <WebMethod>
    Public Shared Function Active_btn(datas As List(Of Integer)) As Boolean
        Dim success As Boolean = False

        Try
            If datas IsNot Nothing AndAlso datas.Count > 0 Then
                Using conn As New SqlConnection(connectionString) ' Ensure you provide the correct connection string
                    conn.Open()

                    ' Convert the list of IDs to a comma-separated string
                    Dim ids As String = String.Join(",", datas)

                    ' Construct the SQL query with the IN clause
                    Dim query As String = "UPDATE MDT_User_Role_Master SET Status = 1 WHERE ID IN (" & ids & ")"

                    Using cmd As New SqlCommand(query, conn)
                        Dim rowsAffected As Integer = cmd.ExecuteNonQuery()
                        success = rowsAffected > 0
                    End Using
                End Using
            End If
        Catch ex As Exception
            ' Log the exception message for debugging
            ' For example, using a logging framework or writing to a file
            ' Logger.LogError(ex.Message)
            success = False
        End Try

        Return success
    End Function

    <WebMethod>
    Public Shared Function InActive_btn(datas As List(Of Integer)) As Boolean
        Dim success As Boolean = False

        Try
            If datas IsNot Nothing AndAlso datas.Count > 0 Then
                Using conn As New SqlConnection(connectionString) ' Ensure you provide the correct connection string
                    conn.Open()

                    ' Convert the list of IDs to a comma-separated string
                    Dim ids As String = String.Join(",", datas)

                    ' Construct the SQL query with the IN clause
                    Dim query As String = "UPDATE MDT_User_Role_Master SET Status = 0 WHERE ID IN (" & ids & ")"

                    Using cmd As New SqlCommand(query, conn)
                        Dim rowsAffected As Integer = cmd.ExecuteNonQuery()
                        success = rowsAffected > 0
                    End Using
                End Using
            End If
        Catch ex As Exception
            ' Log the exception message for debugging
            ' For example, using a logging framework or writing to a file
            ' Logger.LogError(ex.Message)
            success = False
        End Try

        Return success
    End Function


End Class