<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="HMS_User_Management.aspx.vb" Inherits="hms_VB_project.HMS_User_Management" %>

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
        initializeDataTable();

        //Dynamic Checkbox
        $.ajax({
            url: 'HMS_User_Management.aspx/Checkbox_Data',
            type: 'POST',
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            success: function (response) {
                var data = JSON.parse(response.d);
                var Checkboxcontainer = $('#Checkboxdiv');
                data.forEach(function (item) {
                    Checkboxcontainer.append(
                        '<div>' +
                        '<input type="checkbox" id="checkbox_' + item.id + '" name="checkbox_' + item.id + '" value="' + item.id + '">' +
                        '<label for="checkbox_' + item.id + '">' + item.Name + '</label>' +
                        '</div>'
                    );
                });
            },
            error: function (error) {
                alert('Error: ' + error.responseText);
            }
        });

       
        var selectedCheckboxIds = [];

        $('#Checkboxdiv').on('change', 'input[type="checkbox"]', function () {
            var checkboxId = $(this).attr('value');

            if ($(this).is(':checked')) {
                // Add checkbox ID to selectedCheckboxIds array if checked
                if (selectedCheckboxIds.indexOf(checkboxId) === -1) {
                    selectedCheckboxIds.push(checkboxId);
                }
            } else {
                // Remove checkbox ID from selectedCheckboxIds array if unchecked
                var index = selectedCheckboxIds.indexOf(checkboxId);
                if (index !== -1) {
                    selectedCheckboxIds.splice(index, 1);
                }
            }

            // Perform AJAX call to fetch data based on selectedCheckboxIds
            $.ajax({
                url: 'HMS_User_Management.aspx/Checkbox_Data_Fetching',
                type: 'POST',
                data: JSON.stringify({ selectedUserRoles: selectedCheckboxIds }),
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function (response) {
                    
                    ActiveinitializeDataTable(response.d); // Log the response to console for debugging
                },
                error: function (error) {
                    console.error('Error fetching data:', error); // Log any errors to console
                }
            });

            console.log('Selected Checkbox IDs:', selectedCheckboxIds); // Optional: Display selected IDs in console
        });

        $('#sub_btn').click(function(){
            $('#Checkboxdiv input[type = "checkbox"]').prop('checked', false);
            initializeDataTable();
        })
        // All Checkbox click Method
        $('.selectAll').on('click', function () {
            var rows = $('#example').DataTable().rows({ 'search': 'applied' }).nodes();
            $('input[type="checkbox"]', rows).prop('checked', this.checked);
        });

        $('#btnAddEmployee,#btnAddEmployee2').on('click', function () {
            // Show the modal
            $('#exampleModal').modal('show');
        });
        $('#Close_model').on('click', function () {
            $('#Userrole').val('0'),
                $('#UserName').val(""),
                $('#Login_Password').val(""),
                $('#User_Full_Name').val(""),
                $('#User_Email').val("")
        });



        // Add buttom method (Insert Data method)
        $('#Insert_btn').click(function () {
            var temp = '0';
            var userNameregex = /^[a-zA-Z\s]+$/;  // Ensure no numbers and not empty
            var emailregex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            var passwordregex = /^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,16}$/;


            // Gather data from form fields
            var data = {
                userRoll: $('#Userrole').val(),
                UserName: $('#UserName').val(),
                UserPassword: $('#Login_Password').val(),
                UserFullName: $('#User_Full_Name').val(),
                UserEmail: $('#User_Email').val(),
            };

            // Validate input data

            if (!data.UserName || !userNameregex.test(data.UserName)) {
                alert("Please enter a valid name (alphabets and spaces only)");
                temp = '1';

            }

            else if (!data.UserPassword || !passwordregex.test(data.UserPassword)) {
                alert("Please enter a valid password (8-16 characters, at least one capital letter, one lowercase letter, one number, and one special character)");
                temp = '1';

            }

            else if (!data.UserFullName || !userNameregex.test(data.UserFullName)) {
                alert("Please enter a valid full name (alphabets and spaces only)");
                temp = '1';

            }

            else if (!data.UserEmail || !emailregex.test(data.UserEmail)) {
                alert("Please enter a valid email");
                temp = '1';

            }

            if (temp === '0') {

                $.ajax({
                    type: 'POST',
                    url: 'HMS_User_Management.aspx/CheckUserName',
                    data: JSON.stringify({ Username: data.UserName }),
                    contentType: 'application/json; charset=utf-8',
                    dataType: 'json',
                    success: function (response) {
                        console.log(response.d);
                        if (response.d == true) {
                            alert("This username is alrady available Please enter another usernmae");
                        }
                        else {
                            $.ajax({
                                type: 'POST',
                                url: 'HMS_User_Management.aspx/Adddata', // Check if this URL is correct based on your application structure
                                data: JSON.stringify({ Datas: data }),
                                contentType: 'application/json; charset=utf-8',
                                dataType: 'json',
                                success: function (response) {
                                    // Refresh the DataTable
                                    //$('#example').DataTable().ajax.reload(); // Refresh the DataTable
                                    /*$('#exampleModal').modal('hide');*/

                                    alert('Data inserted successfully!');
                                    $('#exampleModal').modal('hide');
                                    initializeDataTable();
                                    $('#Userrole').val('0');
                                    $('#UserName,#Login_Password,#User_Full_Name,#User_Email').val('');

                                },
                                error: function (xhr, status, error) {
                                    alert('Error: ' + error);
                                }
                            });
                        }

                    },
                    error: function (xhr, status, error) {
                        alert('Error: ' + error);
                    }
                });

            }


        });

        //Close Button Method
        $('#Close_btn').click(function () {
            $('#Userrole').val('0');
            $('#UserName,#Login_Password,#User_Full_Name,#User_Email').val('');
        });

    });

    // Active  button click....
    var User_Record = [];
    User_Record = [];
    function ActiveButton() {
        // Collect the user IDs again before making the AJAX call
        $('#example .row-checkbox:checked').each(function () {
            User_Record.push($(this).closest('tr').find('td:eq(1)').text()); // Assuming User_ID is in the second column (index 1)
        });
        if (User_Record.length === 0) {
            alert('Please select the user(s)');
            return;
        }
        $.ajax({
            type: 'POST',
            url: 'HMS_User_Management.aspx/ActiveData',
            data: JSON.stringify({ record: User_Record }),
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            success: function (response) {
                if (response.d) {
                    initializeDataTable();
                    $('#example .row-checkbox, #example .selectAll').prop('checked', false);
                    User_Record.length = 0;
                    alert('Successfully activated the user(s)');
                } else {
                    alert('Please select the user(s)');
                }
            },
            error: function (xhr, status, error) {
                alert('Error: ' + error);
            }
        });
    }

    // Inactive  button click....
    function InActiveButton() {
        // Collect the user IDs again before making the AJAX call
        $('#example .row-checkbox:checked').each(function () {
            User_Record.push($(this).closest('tr').find('td:eq(1)').text()); // Assuming User_ID is in the second column (index 1)
        });
        if (User_Record.length == 0) {
            alert("Please select the user(s)")
            return;
        }
        $.ajax({
            type: 'POST',
            url: 'HMS_User_Management.aspx/InActiveData',
            data: JSON.stringify({ record: User_Record }),
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            success: function (response) {
                if (response.d) {
                    initializeDataTable();
                    $('#example .row-checkbox, #example .selectAll').prop('checked', false);
                    User_Record.length = 0;
                    alert('Successfully Inactivated the user(s)');
                } else {
                    alert('Please select the user(s)');
                }
            },
            error: function (xhr, status, error) {
                alert('Error: ' + error);
            }
        });
    }

    function initializeDataTable() {
        // Destroy any existing DataTable instance to reinitialize
        $('#example').DataTable().destroy();

        // Initialize DataTable with options
        $('#example').DataTable({
            "ajax": {
                "url": "HMS_User_Management.aspx/GetData",
                "type": "POST",
                "dataType": "json",
                "contentType": "application/json; charset=utf-8",
                "dataSrc": function (json) {
                    // Parse JSON response if necessary
                    return JSON.parse(json.d);
                }
            },
            "columns": [
                {
                    data: null,
                    defaultContent: '<input type="checkbox" class="row-checkbox"/>',
                    orderable: false
                },
                { "data": 'User_Id' },
                {
                    "data": 'User_Name',
                    render: function (data, type, row) {
                        return "<a href='#' data-bs-toggle='modal' data-bs-target='#exampleModal2' onclick=\"UpdateData('" + row.User_Id + "')\">" + data + "</a>";
                    }
                },
                { "data": 'UserFull_Name' },
                { "data": 'User_Role_Desc' },
                {
                    "data": 'User_Status',
                    "render": function (data, type, row) {
                        if (data == '1') {
                            return '<span class="active text-success">Active</span>';
                        } else {
                            return '<span class="inactive text-danger">Inactive</span>';
                        }
                    }
                }
            ]
        });
    }
    // Active Data Click Function when we clicke on active radio button....
    function activeRec() {
        $.ajax({
            type: 'POST',
            url: 'HMS_User_Management.aspx/Active_Status',
            data: JSON.stringify({}),  // No parameters to send
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            success: function (response) {
                ActiveinitializeDataTable(response.d);
                /* alert('Active data show');*/
            },
            error: function (xhr, status, error) {
                alert('Error: ' + error);
            }
        });
    }

    //InActive Data click Function when we clicke on inactive radio button....
    function inactive() {
        $.ajax({
            type: 'POST',
            url: 'HMS_User_Management.aspx/InActive_Status',
            data: JSON.stringify({}),
            contentType: 'application/json; charset=utf-8',
            datatype: 'json',
            success: function (response) {
                ActiveinitializeDataTable(response.d);
                /*alert('InActive data show.');*/
            },
            error: function (xhr, status, error) {
                alert('Error: ' + error);
            }
        });
    }

    //All Data show Function when we clicke on alldata radio button....
    function AllData() {
        initializeDataTable();
        /* alert('All Data show.')*/
    }

    // Update data Button method....
    var rowid = 0;
    function UpdateData(rowId) {
        rowid = rowId;
        $.ajax({
            type: 'POST',
            url: 'HMS_User_Management.aspx/GetModal_RowData',
            data: JSON.stringify({ userId: rowId }),
            contentType: 'application/json; charset=utf-8',
            datatype: 'json',
            success: function (response) {
                var userData = JSON.parse(response.d);
                populateModal(userData);

            },
            error: function (xhr, status, error) {
                alert('Error: ' + error);
            }

        });
    }

    // Assign a data in DataTable into model field.....
    function populateModal(userData) {
        // Populate modal fields with user data
        $('#<%=DropDownList1.ClientID %>').val(userData.User_Role);
        $('#UserName2').val(userData.User_Name);
        $('#Login_Password2').val(userData.Login_Password);
        $('#User_Full_Name2').val(userData.UserFull_Name);
        $('#User_Email2').val(userData.User_Email);
        //$('#status2').val(userData.User_Status);

        // Show the modal
        $('#exampleModal2').modal('show');

        // Update button click event
        $('#Update_btn').click('click', function () {

            // Validations 
            var userNameregex = /^[a-zA-Z\s]+$/;  // Ensure no numbers and not empty
            var emailregex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            var passwordregex = /^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,16}$/;

            // Gather updated values from modal fields
            var role = $('#DropDownList1').val();
            var user = $('#UserName2').val();
            var pass = $('#Login_Password2').val();
            var fname = $('#User_Full_Name2').val();
            var email = $('#User_Email2').val();
            //var status = $('#status2').val();
            var rowid1 = rowid; // Pass the User_Id to the server

            // Validation Comparing with ueser input valuse

            if (!userNameregex.test(user)) {
                alert("Please enter a valid name (alphabets and spaces only)");
            }
            else if (!userNameregex.test(fname)) {
                alert("Please enter a valid full name (alphabets and spaces only)");
            }
            else if (!passwordregex.test(pass)) {
                alert("Please enter a valid password (8-16 characters, at least one capital letter, one lowercase letter, one number, and one special character)");

            }
            else if (!emailregex.test(email)) {
                alert("Please enter a valid email");
            }

            // Send updated data to the server
            else {
                $.ajax({

                    type: 'POST',
                    url: 'HMS_User_Management.aspx/Updatedata', // Check if this URL is correct based on your application structure
                    data: JSON.stringify({
                        role: role,
                        user: user,
                        pass: pass,
                        fname: fname,
                        email: email,
                        //status: status,
                        rowid: rowid1
                    }),
                    contentType: 'application/json; charset=utf-8',
                    dataType: 'json',
                    success: function (response) {
                        alert('Data updated successfully!');
                        // Refresh the DataTable
                        $('#exampleModal2').modal('hide');
                        $('#example').DataTable().ajax.reload();
                    },
                    error: function (xhr, status, error) {
                        alert('Error: ' + error);
                    }
                });
            }

        });
    }

    // Updateted , active, inactive Initialize data to DataTable Method...
    function ActiveinitializeDataTable(data) {
        $('#example').DataTable().destroy();
        $('#example').DataTable({
            data: JSON.parse(data),
            columns: [
                {
                    data: null,
                    defaultContent: '<input type="checkbox" class="row-checkbox" />',
                    orderable: false
                    //we can use write this also both are same
                    //data: null,
                    //render: function (data, type, row) {
                    //    return '<input type="checkbox" class="row-checkbox" />';
                    //},
                    //orderable: false
                },
                { "data": 'User_Id' },
                {
                    "data": 'User_Name',
                    render: function (data, type, row) {
                        // return "<a href='#' class='modal-link' onclick=\"UpdateData('" + row.User_Id + "')\">" + data + "</a>";
                        return "<a href='#' data-bs-toggle='modal' data-bs-target='#exampleModal2' onclick=\"UpdateData('" + row.User_Id + "')\">" + data + "</a>";
                    }
                },
                { "data": 'UserFull_Name' },
                { "data": 'User_Role_Desc' },
                {
                    "data": 'User_Status',
                    "render": function (data, type, row, meta) {
                        if (data == '1') {
                            return '<span class="active text-success">Active</span>';
                        } else {
                            return '<span class="inactive text-danger">Inactive</span>';
                        }
                    }
                }
            ]
        });
    }
</script>
<body>
    <form runat="server">

        <div class="container mt-5">
            <p class="text-center h2 p-4">User Management</p>
        </div>
        <div class="container">
            <div class="row">
                <div class="col-sm-3 bg-light pt-5 border border-primary rounded ">
                    <div id="Checkboxdiv">

                    </div>
                    <button type="button" id="sub_btn" class="btn btn btn-primary">Clear</button>
                </div>
                <div class="col-sm-9">
                    <div class="button-container2">
                        
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
                                <th>User Login Name</th>
                                <th>User Full Name</th>
                                <th>User Role</th>
                                <th>Status</th>
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
                                <th>User Login Name</th>
                                <th>User Full Name</th>
                                <th>User Role</th>
                                <th>Status</th>
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
                                    <asp:DropDownList ID="Userrole" runat="server" Style="width: 185px;"></asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <th>
                                    <label for="fname">Login User Name</label>
                                </th>
                                <td>
                                    <span>&emsp;&emsp;&emsp;:</span>
                                    <input type="text" id="UserName" name="UserName" />
                                </td>
                            </tr>
                            <tr>
                                <th>
                                    <label for="fname">Login Password</label>
                                </th>
                                <td>
                                    <span>&emsp;&emsp;&emsp;:</span>
                                    <input type="password" id="Login_Password" name="" />
                                </td>
                            </tr>
                            <tr>
                                <th>
                                    <label for="fname">Full Name of User</label>
                                </th>
                                <td>
                                    <span>&emsp;&emsp;&emsp;:</span>
                                    <input type="text" id="User_Full_Name" name="UserName" />
                                </td>
                            </tr>
                            <tr>
                                <th>
                                    <label for="fname">User Email ID</label>
                                </th>
                                <td>
                                    <span>&emsp;&emsp;&emsp;:</span>
                                    <input type="email" id="User_Email" name="UserName" />
                                </td>
                            </tr>
                            <%--<%-- <tr>
                                <th>
                                    <label for="status">Status</label>
                                </th>
                                <td>
                                    <span>&emsp;&emsp;&emsp;:</span>
                                    <select id="status" name="Status">
                                        <option value="1">Active</option>
                                        <option value="0">Inactive</option>
                                    </select>
                                </td>
                            </tr>--%>
                        </table>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" id="Close_btn" data-dismiss="modal">Close</button>
                        <button type="button" class="btn btn-primary" id="Insert_btn">Add</button>
                    </div>
                </div>
            </div>
        </div>

        <!--Updata Data Modal Section-->
        <div class="modal fade" id="exampleModal2" tabindex="-1" data-backdrop="static">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel2">User Update</h5>
                        <button type="button" class="close" data-dismiss="modal">
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
                                    <asp:DropDownList ID="DropDownList1" runat="server" Style="width: 185px;"></asp:DropDownList>

                                </td>
                            </tr>
                            <tr>
                                <th>
                                    <label for="fname">Login User Name</label>
                                </th>
                                <td>
                                    <span>&emsp;&emsp;&emsp;:</span>
                                    <input type="text" id="UserName2" name="UserName" />
                                </td>
                            </tr>
                            <tr>
                                <th>
                                    <label for="fname">Login Password</label>
                                </th>
                                <td>
                                    <span>&emsp;&emsp;&emsp;:</span>
                                    <input type="password" id="Login_Password2" name="" />
                                </td>
                            </tr>
                            <tr>
                                <th>
                                    <label for="fname">Full Name of User</label>
                                </th>
                                <td>
                                    <span>&emsp;&emsp;&emsp;:</span>
                                    <input type="text" id="User_Full_Name2" name="UserName" />
                                </td>
                            </tr>
                            <tr>
                                <th>
                                    <label for="fname">User Email ID</label>
                                </th>
                                <td>
                                    <span>&emsp;&emsp;&emsp;:</span>
                                    <input type="email" id="User_Email2" name="UserName" />
                                </td>
                            </tr>
                            <%--<tr>
                                <th>
                                    <label for="status">Status</label>
                                </th>
                                <td>
                                    <span>&emsp;&emsp;&emsp;:</span>
                                    <select id="status2" name="Status">
                                        <option value="1">Active</option>
                                        <option value="0">Inactive</option>
                                    </select>
                                </td>
                            </tr>--%>
                        </table>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        <button type="button" class="btn btn-primary" id="Update_btn">Update</button>
                    </div>
                </div>
            </div>
        </div>

    </form>
</body>
</html>
