Imports System.Data.SqlClient
Imports System.Web.Script.Services
Imports System.Web.Services
Imports Newtonsoft.Json

'Public Class HMS_User_Management
'    Inherits System.Web.UI.Page

'    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

'    End Sub

'End Class

Imports System
Imports System.Collections.Generic

Imports System.Linq
Imports System.Web
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports System.Configuration
Imports System.Data

Imports System.Web.Script.Serialization
Imports System.Drawing
Imports System.Web.Security
Imports System.Collections


Public Class Role
    Public Property id As String
    Public Property description As String
End Class

Public Class checkboxitems
    Public Property id As Integer
    Public Property Name As String
End Class

Public Class insertValue
        Public Property userRoll As String
        Public Property UserName As String
        Public Property UserPassword As String
        Public Property UserFullName As String
        Public Property UserEmail As String
        Public Property Status As String
    End Class

    Partial Public Class HMS_User_Management
        Inherits System.Web.UI.Page

        Public Shared connectionString As String = ConfigurationManager.ConnectionStrings("mytable").ConnectionString
    Private d As SqlDataReader
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
            If Not IsPostBack Then
                Dropdownlist()
            End If
        End Sub

    <WebMethod>
    Public Shared Function CheckUserName(ByVal Username As String) As Boolean
        Dim result As String = ""
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("mytable").ConnectionString
        Dim query As String = "select User_Name from MDT_Reg_User where User_Name=@userName "
        Dim conn As SqlConnection = New SqlConnection(connectionString)
        Dim cmd As SqlCommand = New SqlCommand(query, conn)
        cmd.Parameters.AddWithValue("@userName", Username)
        conn.Open()
        Dim dr As SqlDataReader = cmd.ExecuteReader()

        If dr.Read() Then
            result = dr("User_Name").ToString()
        End If

        If result.ToLower() = Username.ToLower() Then
            Return True
        Else
            Return False
        End If
    End Function

    <WebMethod>
    Public Shared Function Checkbox_Data_Fetching(selectedUserRoles As List(Of String)) As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("mytable").ConnectionString
        Dim query As String = "SELECT User_Id, User_Name, UserFull_Name, User_Role_Desc, User_Status FROM MDT_Reg_User WHERE User_Role_Desc IN ({0})"

        Using conn As New SqlConnection(connectionString)
            Try
                conn.Open()
                If selectedUserRoles.Count = 0 Then
                    query = "SELECT User_Id, User_Name, UserFull_Name, User_Role_Desc, User_Status FROM MDT_Reg_User"
                End If
                ' Constructing the IN clause with parameters
                Dim parameters As New List(Of String)
                For i As Integer = 0 To selectedUserRoles.Count - 1
                    parameters.Add("@UserRole" & i)
                Next
                query = String.Format(query, String.Join(",", parameters))

                Using cmd As New SqlCommand(query, conn)
                    ' Adding parameters
                    For i As Integer = 0 To selectedUserRoles.Count - 1
                        cmd.Parameters.Add(New SqlParameter("@UserRole" & i, selectedUserRoles(i)))
                    Next

                    Dim dt As New System.Data.DataTable()
                    Dim data As New List(Of Dictionary(Of String, Object))()

                    Using da As New SqlDataAdapter(cmd)
                        da.Fill(dt)

                        ' Loop through each row in the result set
                        For Each row As DataRow In dt.Rows
                            Dim dict As New Dictionary(Of String, Object)()

                            ' Iterate through each column in the row
                            For Each col As DataColumn In dt.Columns
                                If col.ColumnName = "User_Role_Desc" Then
                                    Dim roleId As Integer = Convert.ToInt32(row(col))
                                    Dim roleDesc As String = GetRoleDescription(roleId)
                                    dict(col.ColumnName) = roleDesc
                                Else
                                    dict(col.ColumnName) = row(col)
                                End If
                            Next

                            ' Add the row data to the list
                            data.Add(dict)
                        Next
                    End Using

                    ' Serialize data to JSON format and return
                    Return JsonConvert.SerializeObject(data)
                End Using

            Catch ex As Exception
                Throw New Exception("An error occurred while fetching data.", ex)
            End Try
        End Using
    End Function


    <WebMethod>
    Public Shared Function GetData() As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("mytable").ConnectionString
        Dim query As String = "select User_Id,User_Name,UserFull_Name,User_Role_Desc,User_Status from MDT_Reg_User"

        Using conn As SqlConnection = New SqlConnection(connectionString)
            Dim da As SqlDataAdapter = New SqlDataAdapter(query, conn)
            Dim dt As System.Data.DataTable = New System.Data.DataTable()
            da.Fill(dt)
            Dim data As List(Of Dictionary(Of String, Object)) = New List(Of Dictionary(Of String, Object))()

            For Each row As DataRow In dt.Rows
                Dim dict As Dictionary(Of String, Object) = New Dictionary(Of String, Object)()

                For Each col As DataColumn In dt.Columns

                    If col.ColumnName = "User_Role_Desc" Then
                        Dim roleId As Integer = Convert.ToInt32(row(col))
                        Dim roleDesc As String = GetRoleDescription(roleId)
                        dict(col.ColumnName) = roleDesc
                    Else
                        dict(col.ColumnName) = row(col)
                    End If
                Next

                data.Add(dict)
            Next

            Return JsonConvert.SerializeObject(data)
        End Using
    End Function

    Private Shared Function GetRoleDescription(ByVal roleId As Integer) As String
            Dim result As String = ""
            Dim connectionString As String = ConfigurationManager.ConnectionStrings("mytable").ConnectionString
            Dim query As String = "select User_Role_Desc  from MDT_User_Role_Master where id=@id"
            Dim conn As SqlConnection = New SqlConnection(connectionString)
            Dim cmd As SqlCommand = New SqlCommand(query, conn)
            cmd.Parameters.AddWithValue("@id", roleId)
            conn.Open()
            Dim dr As SqlDataReader = cmd.ExecuteReader()

            If dr.Read() Then
                result = dr("User_Role_Desc").ToString()
            End If

            Return result
        End Function

        <WebMethod>
        <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
        Public Shared Function Active_Status() As String
            Dim connectionString As String = ConfigurationManager.ConnectionStrings("mytable").ConnectionString
            Dim query As String = "SELECT User_Id, User_Name, UserFull_Name, User_Role_Desc, User_Status FROM MDT_Reg_User WHERE User_Status = 1"

            Using conn As SqlConnection = New SqlConnection(connectionString)

                Try
                    conn.Open()

                    Using cmd As SqlCommand = New SqlCommand(query, conn)
                        Dim da As SqlDataAdapter = New SqlDataAdapter(cmd)
                        Dim dt As System.Data.DataTable = New System.Data.DataTable()
                        da.Fill(dt)
                        Dim data As List(Of Dictionary(Of String, Object)) = New List(Of Dictionary(Of String, Object))()

                        For Each row As DataRow In dt.Rows
                            Dim dict As Dictionary(Of String, Object) = New Dictionary(Of String, Object)()

                            For Each col As DataColumn In dt.Columns

                                If col.ColumnName = "User_Role_Desc" Then
                                    Dim roleId As Integer = Convert.ToInt32(row(col))
                                    Dim roleDesc As String = GetRoleDescription(roleId)
                                    dict(col.ColumnName) = roleDesc
                                Else
                                    dict(col.ColumnName) = row(col)
                                End If
                            Next

                            data.Add(dict)
                        Next

                        Return JsonConvert.SerializeObject(data)
                    End Using

                Catch ex As Exception
                    Throw New Exception("An error occurred while fetching data.", ex)
                End Try
            End Using
        End Function

        <WebMethod>
        <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
        Public Shared Function InActive_Status() As String
            Dim connectionString As String = ConfigurationManager.ConnectionStrings("mytable").ConnectionString
            Dim query As String = "SELECT User_Id, User_Name, UserFull_Name, User_Role_Desc, User_Status FROM MDT_Reg_User WHERE User_Status = 0"

            Using conn As SqlConnection = New SqlConnection(connectionString)

                Try
                    conn.Open()

                    Using cmd As SqlCommand = New SqlCommand(query, conn)
                        Dim da As SqlDataAdapter = New SqlDataAdapter(cmd)
                        Dim dt As System.Data.DataTable = New System.Data.DataTable()
                        da.Fill(dt)
                        Dim data As List(Of Dictionary(Of String, Object)) = New List(Of Dictionary(Of String, Object))()

                        For Each row As DataRow In dt.Rows
                            Dim dict As Dictionary(Of String, Object) = New Dictionary(Of String, Object)()

                            For Each col As DataColumn In dt.Columns

                                If col.ColumnName = "User_Role_Desc" Then
                                    Dim roleId As Integer = Convert.ToInt32(row(col))
                                    Dim roleDesc As String = GetRoleDescription(roleId)
                                    dict(col.ColumnName) = roleDesc
                                Else
                                    dict(col.ColumnName) = row(col)
                                End If
                            Next

                            data.Add(dict)
                        Next

                        Return JsonConvert.SerializeObject(data)
                    End Using

                Catch ex As Exception
                    Throw New Exception("An error occurred while fetching data.", ex)
                End Try
            End Using
        End Function

        <WebMethod>
        Public Shared Function ActiveData(ByVal record As List(Of Integer)) As Boolean
            Dim success As Boolean = False

            Try

                If record.Count > 0 Then

                    Using conn As SqlConnection = New SqlConnection(connectionString)

                        For Each id As Integer In record
                            Dim query As String = "update MDT_Reg_User set User_Status='1' where User_Id=@UserId"
                            Dim cmd As SqlCommand = New SqlCommand(query, conn)
                            cmd.Parameters.AddWithValue("@UserId", id)
                            conn.Open()
                            cmd.ExecuteNonQuery()
                            conn.Close()
                        Next

                        success = True
                    End Using
                End If

            Catch ex As Exception
                success = False
            End Try

            Return success
        End Function

        <WebMethod>
        Public Shared Function InActiveData(ByVal record As List(Of Integer)) As Boolean
            Dim success As Boolean = False

            Try

                If record.Count > 0 Then

                    Using conn As SqlConnection = New SqlConnection(connectionString)

                        For Each id As Integer In record
                            Dim query As String = "update MDT_Reg_User set User_Status='0' where User_Id=@UserId"
                            Dim cmd As SqlCommand = New SqlCommand(query, conn)
                            cmd.Parameters.AddWithValue("@UserId", id)
                            conn.Open()
                            cmd.ExecuteNonQuery()
                            conn.Close()
                        Next

                        success = True
                    End Using
                End If

            Catch ex As Exception
                success = False
            End Try

            Return success
        End Function

        Public Shared Function GetRole(ByVal role As String) As String
            Dim roleDesc As String = Nothing
            Dim query As String = "SELECT ID,User_Role_Desc FROM [MDT_User_Role_Master] WHERE ID = @Role"

            Using conn As SqlConnection = New SqlConnection(connectionString)

                Using cmd As SqlCommand = New SqlCommand(query, conn)
                    cmd.Parameters.AddWithValue("@Role", role)
                    conn.Open()

                    Using dr As SqlDataReader = cmd.ExecuteReader()

                        If dr.Read() Then
                            roleDesc = dr("ID").ToString()
                        End If
                    End Using
                End Using
            End Using

            Return roleDesc
        End Function

        <WebMethod>
        Public Shared Function Adddata(ByVal Datas As insertValue) As String
            Try
                Dim role As String = Datas.userRoll
                Dim str As String = GetRole(role)

                Using conn As SqlConnection = New SqlConnection(connectionString)
                    Dim query As String = "INSERT INTO MDT_Reg_User (User_Role_Desc, User_Name, user_Password, UserFull_Name, User_email, User_Status) VALUES (@userRoll, @UserName, @UserPassword, @UserFullName, @UserEmail, @Status)"
                    Dim cmd As SqlCommand = New SqlCommand(query, conn)
                    cmd.Parameters.AddWithValue("@userRoll", str)
                    cmd.Parameters.AddWithValue("@UserName", Datas.UserName)
                    cmd.Parameters.AddWithValue("@UserPassword", Datas.UserPassword)
                    cmd.Parameters.AddWithValue("@UserFullName", Datas.UserFullName)
                    cmd.Parameters.AddWithValue("@UserEmail", Datas.UserEmail)
                    cmd.Parameters.AddWithValue("@Status", "1")
                    conn.Open()
                    cmd.ExecuteNonQuery()
                End Using

                Return "Data Inserted"
            Catch ex As Exception
                Return "Error inserting data: " & ex.Message
            End Try
        End Function

        <System.Web.Services.WebMethod>
        Public Shared Function Updatedata(ByVal role As String, ByVal user As String, ByVal pass As String, ByVal fname As String, ByVal email As String, ByVal rowid As Integer) As String
            Try

                Using conn As SqlConnection = New SqlConnection(connectionString)
                    Dim query As String = "UPDATE MDT_Reg_User SET User_Role_Desc = @userRoll, User_Name = @UserName, user_Password = @UserPassword, UserFull_Name = @UserFullName, User_email = @UserEmail, User_Status = @Status WHERE User_Id = @uid"
                    Dim cmd As SqlCommand = New SqlCommand(query, conn)
                    cmd.Parameters.AddWithValue("@userRoll", role)
                    cmd.Parameters.AddWithValue("@UserName", user)
                    cmd.Parameters.AddWithValue("@UserPassword", pass)
                    cmd.Parameters.AddWithValue("@UserFullName", fname)
                    cmd.Parameters.AddWithValue("@UserEmail", email)
                    cmd.Parameters.AddWithValue("@Status", "1")
                    cmd.Parameters.AddWithValue("@uid", rowid)
                    conn.Open()
                    cmd.ExecuteNonQuery()
                End Using

                Return ""
            Catch ex As Exception
                Return "Error updating data: " & ex.Message
            End Try
        End Function

        Private Sub Dropdownlist()
            Dim connectionString As String = ConfigurationManager.ConnectionStrings("mytable").ConnectionString
            Dim query1 As String = "SELECT id, User_Role_Desc FROM [MDT_User_Role_Master]"

            Using conn As New SqlConnection(connectionString)
                Dim cmd As New SqlCommand(query1, conn)

                Try
                    conn.Open()
                    Dim reader As SqlDataReader = cmd.ExecuteReader()

                    While reader.Read()
                        Userrole.Items.Add(New ListItem(reader("User_Role_Desc").ToString(), reader("id").ToString()))
                        DropDownList1.Items.Add(New ListItem(reader("User_Role_Desc").ToString(), reader("id").ToString()))
                    End While

                    reader.Close()
                Catch ex As Exception
                    ' Handle the exception (logging, displaying an error message, etc.)
                Finally
                    If conn.State = ConnectionState.Open Then
                        conn.Close()
                    End If
                End Try

                Userrole.Items.Insert(0, New ListItem("--Select User Role--", "0"))
                DropDownList1.Items.Insert(0, New ListItem("--Select User Role--", "0"))
            End Using
        End Sub

    <WebMethod>
    Public Shared Function GetModal_RowData(ByVal userId As String) As String
        Dim conn As SqlConnection = New SqlConnection(connectionString)
        Dim query As String = "SELECT User_Role_Desc, User_Name, user_Password, UserFull_Name, User_email, User_Status FROM MDT_Reg_User WHERE User_Id = @UserId"

        Using cmd As SqlCommand = New SqlCommand(query, conn)
            cmd.Parameters.AddWithValue("@UserId", userId)
            conn.Open()
            Dim reader As SqlDataReader = cmd.ExecuteReader()

            If reader.Read() Then
                Dim userData = New With {
                    .User_Name = reader("User_Name").ToString(),
                    .Login_Password = reader("user_Password").ToString(),
                    .UserFull_Name = reader("UserFull_Name").ToString(),
                    .User_Email = reader("User_email").ToString(),
                    .User_Status = Convert.ToInt32(reader("User_Status")),
                    .User_Role = Convert.ToInt32(reader("User_Role_Desc"))
                }
                Return JsonConvert.SerializeObject(userData)
            End If
        End Using

        Return Nothing
    End Function

    'Checkbox code'
    <WebMethod()>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function Checkbox_Data() As String
        Dim items As New List(Of checkboxitems)
        Using conn As New SqlConnection(connectionString)
            conn.Open()
            Dim query As String = "SELECT ID, User_Role_Desc FROM MDT_User_Role_Master"
            Using cmd As New SqlCommand(query, conn)
                Using dr As SqlDataReader = cmd.ExecuteReader()
                    While dr.Read()
                        Dim item As New checkboxitems()
                        item.id = Convert.ToInt32(dr("ID"))
                        item.Name = dr("User_Role_Desc").ToString()
                        items.Add(item)
                    End While
                End Using
            End Using
        End Using

        ' Serialize the list to JSON using JsonConvert
        Return JsonConvert.SerializeObject(items)
    End Function
End Class

