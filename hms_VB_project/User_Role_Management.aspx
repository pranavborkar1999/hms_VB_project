<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="User_Role_Management.aspx.vb" Inherits="hms_VB_project.User_Role_Management" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>HMS DataTable</title>
    <!--Bootstrap CDN link-->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/5.3.0/css/bootstrap.min.css" />
    <!--Data table csss CDN link-->
    <link rel="stylesheet" href="https://cdn.datatables.net/2.0.8/css/dataTables.bootstrap5.css" />
    <link rel="stylesheet" href="DataTable.css">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">




    <!--Jquery CDN links-->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/2.0.8/js/dataTables.js"></script>
    <script src="https://cdn.datatables.net/2.0.8/js/dataTables.bootstrap5.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>



    <!--new datatable display links-->
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.11.4/css/jquery.dataTables.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.11.4/js/jquery.dataTables.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</head>
<script>
    $(document).ready(function () {
        Initialization();
        $('.selectAll').on('click', function () {
            var rows = $('#example').DataTable().rows({ 'search': 'applied' }).nodes();
            $('input[type="checkbox"]', rows).prop('checked', this.checked);
        });
        // Add button
        $('#btnAddEmployee').on('click', function () {
            $('#exampleModal').modal('show')
        });
        //Insert Button
        $('#Insert_btn').click(function () {
            var temp = '0';
            var userNameregex = /^[a-zA-Z\s]+$/;  // Ensure no numbers and not empty
            var data = {
                UserRole: $('#UserRole').val(),
                UserName: $('#UserName').val(),
                UserRDesc: $('#User_Role_Description').val()
            };
            if (!userNameregex.test(data.UserRole)) {
                alert("User Role does not be empty");
                temp = 1;
            }
            else if (!userNameregex.test(data.UserName)) {
                alert("User Name does not be empty");
                temp = 1;
            }
            else if (!userNameregex.test(data.UserRDesc)) {
                alert("User Role Description does not be empty");
                temp = 1;
            }

            if (temp == 0) {
                $.ajax({
                    type: 'POST',
                    url: 'User_Role_Management.aspx/InsertData',
                    data: JSON.stringify({ datas: data }),
                    contentType: 'application/json; charset=utf-8',
                    dataType: 'json',
                    success: function (response) {
                        
                        alert('Data Insert Successfully');
                        $('#UserRole, #UserName, #User_Role_Description').val('');
                        $('#exampleModal').modal('hide');
                        Initialization();
                       
                    },
                    error: function (xhr, status, error) {
                        alert('Error: ' + error);
                    }

                });
            }
        });
        // close Button
        $('#Close_btn').click(function () {
            $('#UserRole, #UserName, #User_Role_Description').val('');
        });
    });
    function Initialization() {
        $('#example').DataTable().destroy();
        $('#example').DataTable({
            "ajax": {
                "url": "User_Role_Management.aspx/GetData",
                "type": "POST",
                "dataType": "json",
                "contentType": "application/json; charset=utf-8",
                "dataSrc": function (json) {
                    return JSON.parse(json.d);
                }
            },
            "columns": [
                {
                    data: null,
                    orderable: false,
                    render: function (data, type, row) {
                        return '<input type="checkbox" class="row-checkbox" data-user-id="' + row.ID + '"/>';
                    }
                   
                },
                {
                    data: null,
                    render: function (data, type, row, meta) {
                        return meta.row + 1;
                    }
                },
                {
                    data: 'User_Role_Desc',
                    render: function (data, type, row, meta) {
                        if (row.Status === false || row.Status === 0) {
                            return '<span class="text-danger">' + data + '</span>';
                        } else {
                            return data;
                        }
                    }
                },
                { data: 'USER_ROLE_NAME' },
                { data: 'USER_ROLE_TEXT' }
            ]
        });
    }

    function ActiveinitializeDataTable(data) {
        $('#example').DataTable().destroy();
        $('#example').DataTable({
            data: JSON.parse(data),
            columns: [
                {
                    data: null,
                    orderable: false,
                    render: function (data, type, row) {
                        return '<input type="checkbox" class="row-checkbox" data-user-id="' + row.ID + '"/>';
                    }
                },
                {
                    data: null,
                    render: function (data, type, row, meta) {
                        return meta.row + 1;
                    }
                },
                {
                    data: 'User_Role_Desc',
                    render: function (data, type, row, meta) {
                        if (row.Status === false || row.Status === 0) {
                            return '<span class="text-danger">' + data + '</span>';
                        } else {
                            return data;
                        }
                    }
                },
                { data: 'USER_ROLE_NAME' },
                { data: 'USER_ROLE_TEXT' }
            ]
        });
    }

    function activeRec() {
        $.ajax({
            type: 'POST',
            url: 'User_Role_Management.aspx/Active_Status',
            data: JSON.stringify({}),  // No parameters to send
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            success: function (response) {
                ActiveinitializeDataTable(response.d);
                alert("Successfully fetched data");
            },
            error: function (xhr, status, error) {
                alert('Error: ' + error);
            }
        });
    }

    function inactive() {
        $.ajax({
            type: 'POST',
            url: 'User_Role_Management.aspx/InActive_Status',
            data: JSON.stringify({}),
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            success: function (response) {
                ActiveinitializeDataTable(response.d);
                alert("Successfully fetched data");
            },
            error: function (xhr, status, error) {
                console.error('AJAX Error: ' + error);
                console.error('Status: ' + status);
                console.error(xhr);
                alert('Error: ' + error);
            }
        });
    }
    function AllData() {
        Initialization();
        alert("Successfully fetched data");
    }
    //Active button
    var User_Record = []; // Initialize the array to store user IDs

    function ActiveButton() {
        // Attach a change event listener to checkboxes
        $('#example .row-checkbox:checked').each(function () {
            var UserId = $(this).data('user-id');
            User_Record.push(UserId);
        });
        if (User_Record.length === 0) {
            alert('Please select the user(s)');
            return;
        };

        // Make an AJAX request to send the user records
        $.ajax({
            type: 'POST',
            url: 'User_Role_Management.aspx/Active_btn',
            data: JSON.stringify({ datas: User_Record }), // Properly format the data
            contentType: 'application/json; charset=utf-8', // Set content type
            dataType: 'json',
            success: function (response) {
                alert("Active data successfully updated.");

                Initialization(); // Call Initialization function after successful response
                User_Record = [];
            },
            error: function (xhr, status, error) {
                alert('Error: ' + error); // Display error message
            }
        });
    }
    function InActiveButton() {
        // Attach a change event listener to checkboxes
        $('#example .row-checkbox:checked').each(function () {
            var UserId = $(this).data('user-id');
            User_Record.push(UserId);
        });
        if (User_Record.length === 0) {
            alert('Please select the user(s)');
            return;
        };

        // Make an AJAX request to send the user records
        $.ajax({
            type: 'POST',
            url: 'User_Role_Management.aspx/InActive_btn',
            data: JSON.stringify({ datas: User_Record }), // Properly format the data
            contentType: 'application/json; charset=utf-8', // Set content type
            dataType: 'json',
            success: function (response) {
                alert("Active data successfully updated.");

                Initialization(); // Call Initialization function after successful response
                User_Record = [];
            },
            error: function (xhr, status, error) {
                alert('Error: ' + error); // Display error message
            }
        });
    }



</script>
<body>
    <form runat="server">
        <div class="container mt-5">
            <p class="text-center h2 p-4">User Management</p>
        </div>

        <div class="container">
            <div class="button-container2">
                <button type="button" id="btnAddEmployee" class="btn btn btn">Add</button>
            </div>
            <div class="button-container1">
                <button type="button" id="btnActive" onclick="ActiveButton()" class="btn btn btn-primary">Active</button>
                <button type="button" id="btnInactive" onclick="InActiveButton()" class="btn btn btn-primary">Inactive</button>
            </div>
            <div class="Select_Readio">
                <input type="radio" id="Act1" onclick="activeRec()" name="checked_active_inactive" value="Active" />
                <label for="html">Active</label>
                <input type="radio" id="Inactive_rbtn" onclick="inactive()" name="checked_active_inactive" value="Inactive" />
                <label for="html">Not Active User</label>
                <input type="radio" id="All_users" onclick="AllData()" name="checked_active_inactive" value="All_user" />
                <label for="html">All User</label>
            </div>

            <table id="example" class="table table-striped" style="width: 100%">
                <thead>
                    <tr>
                        <th>
                            <input type="checkbox" class="selectAll" /></th>
                        <th>Sr No</th>
                        <th>User Role id</th>
                        <th>User Role Name</th>
                        <th>User Role Description</th>
                        
                    </tr>
                </thead>
                <tbody>
                </tbody>
                <tfoot>
                    <tr>
                        <!-- <th><input type="checkbox"/></th>-->
                        <th>
                            <input type="checkbox" class="selectAll" /></th>
                        <th>Sr No</th>
                        <th>User Role id</th>
                        <th>User Role Name</th>
                        <th>User Role Description</th>
                        
                    </tr>
                </tfoot>
            </table>
            <div class="button-container2">
                <button type="button" id="btnAddEmployee2" class="btn btn btn">Add</button>
            </div>
            <div class="button-container1">
                <button type="button" id="btnActive2" onclick="ActiveButton()" class="btn btn btn-primary">Active</button>
                <button type="button" id="btnInactive2" onclick="InActiveButton()" class="btn btn btn-primary">Inactive</button>
            </div>

        </div>


        <!-- Add data modal Section -->

        <div class="modal fade" id="exampleModal" tabindex="-1" data-backdrop="static">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel">Add User</h5>
                        <button type="button" class="close" id="Close_model" data-dismiss="modal">
                            <span>&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <table>
                            <tr>
                                <th>
                                    <label for="fname">User Role</label>
                                </th>
                                <td>
                                    <span>&emsp;&emsp;&emsp;:</span>
                                    <input type="text" id="UserRole" name="UserRole" />
                                </td>
                            </tr>
                            <tr>
                                <th>
                                    <label for="fname">User Role Name</label>
                                </th>
                                <td>
                                    <span>&emsp;&emsp;&emsp;:</span>
                                    <input type="text" id="UserName" name="UserName" />
                                </td>
                            </tr>
                            <tr>
                                <th>
                                    <label for="fname">User Role Description</label>
                                </th>
                                <td>
                                    <span>&emsp;&emsp;&emsp;:</span>
                                    <input type="text" id="User_Role_Description" name="User_Role_Description" />
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" id="Close_btn" data-dismiss="modal">Close</button>
                        <button type="button" class="btn btn-primary" id="Insert_btn">Add</button>
                    </div>
                </div>
            </div>
        </div>

    </form>
</body>
</html>
