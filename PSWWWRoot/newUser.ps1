@"
  <div class="starter-template">
    <h1>New Exchange Hybrid Mailbox User</h1>
    <p class="lead">Provisioning form</p>
    <div class="progress">
      <div class="progress-bar progress-bar-striped progress-bar-animated" role="progressbar" style="width: 10%;" aria-valuenow="10" aria-valuemin="0" aria-valuemax="100">10%</div>
    </div>
  </div>



      <form method="POST" action="?page=newUserCreate" id="createForm">
  <div class="form-group">
    <label for="userselect">User account</label>
    <div id="userSpinner" class="spinner-border spinner-border-sm" role="status">
        <span class="sr-only">Loading...</span>
    </div>
    <select class="form-control" id="userselect" aria-describedby="userselectHelp" name="UPN">
      <option value="false">Loading users without a mailbox...</option>
    </select>
    <small id="userselectHelp" class="form-text text-muted">This is the user we want to mail enable. Only users newer than 2 months and with a defined Department attribute are shown.
        (<input type="checkbox" id="noFilter" name="nofilter" value="true">
        <label for="noFilter"> disable filter.)</label>
    </small>
  </div>

  <div class="form-group">
    <label for="licselect">Licensing</label>
    <div id="licSpinner" class="spinner-border spinner-border-sm" role="status">
        <span class="sr-only">Loading...</span>
    </div>
    <select class="form-control" id="licselect" aria-describedby="licselectHelp" name="license">
      <option value="false">Loading license groups...</option>
    </select>
    <small id="licselectHelp" class="form-text text-muted">You will need to select a licensing group that includes Exchange Online.</small>
  </div>

  <button type="submit" class="btn btn-primary" id="createSubmit">Mail enable selected user</button>
    </form>


    <script>
        `$(document).ready(function() {
            console.log( "ready to fetch data!" );

            function getFieldData() {
                `$('#userSpinner').show();
                `$('#licSpinner').show();
                `$(".progress-bar").addClass("progress-bar-striped progress-bar-animated");
                `$('.progress-bar').css('width', '10'+'%').attr('aria-valuenow', '10').html('10'+'%');

                if (`$('#noFilter').is(":checked"))
                {
                    var mbxQueryUrl = "queryNoMBXUsers.ps1?Filter=false"
                } else {
                    var mbxQueryUrl = "queryNoMBXUsers.ps1?Filter=true"
                }

                $.getJSON(mbxQueryUrl, function(json){
                    `$('#userselect').empty();
                    `$('#userselect').append(`$('<option value ="false">').text("Select a user..."));
                    $.each(json, function(i, obj){
                            var displayName = obj.Name + " - " + obj.UserPrincipalName;
                            `$('#userselect').append(`$('<option>').text(displayName).attr('value', obj.UserPrincipalName));
                    });
                    `$('.progress-bar').css('width', '20'+'%').attr('aria-valuenow', '20').html('20'+'%');
                    `$('#userSpinner').hide();

                    $.getJSON("queryLicGroups.ps1", function(json){
                        `$('#licselect').empty();
                        `$('#licselect').append(`$('<option value ="false">').text("Select a license group..."));
                        $.each(json, function(i, obj){
                                var displayName = obj.Name;
                                `$('#licselect').append(`$('<option>').text(displayName).attr('value', obj.SamAccountName));
                        });
                        `$('.progress-bar').css('width', '30'+'%').attr('aria-valuenow', '30').html('30'+'%');
                        `$(".progress-bar").removeClass("progress-bar-striped progress-bar-animated");
                        `$('#licSpinner').hide();
                    });
                });
            }


            `$("#createForm").submit(function (e) {

                //disable the submit button
                `$("#createSubmit").attr("disabled", true);

                `$('.progress-bar').css('width', '40'+'%').attr('aria-valuenow', '40').html('40'+'%');
                `$(".progress-bar").addClass("progress-bar-striped progress-bar-animated");

                return true;

            });

            checkOptions();
            `$("#userselect").change(checkOptions);
            `$("#licselect").change(checkOptions);
            getFieldData();
            `$("#noFilter").change(getFieldData);
            

            function checkOptions() {
              var userSelected = false;
              var licSelected = false;

              `$("#userselect").each(function(index, element) {
                if ( `$(element).val() != "false" ) {
                  userSelected = true;
                }
              });

              `$("#licselect").each(function(index, element) {
                if ( `$(element).val() != "false" ) {
                  licSelected = true;
                }
              });

              if (userSelected && licSelected) {
                `$('#createSubmit').removeAttr("disabled");
              } else {
                `$('#createSubmit').attr("disabled","disabled");
              };
            }

        });
    </script>
"@