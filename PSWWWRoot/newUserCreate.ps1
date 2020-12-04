$upn = [uri]::UnescapeDataString($PoSHPost.UPN)
$license = [uri]::UnescapeDataString($PoSHPost.license)

@"
  <div class="starter-template">
    <h1>New Exchange Hybrid Mailbox User</h1>
    <p class="lead">Provisioning form</p>
    <div class="progress">
      <div class="progress-bar progress-bar-striped progress-bar-animated" role="progressbar" style="width: 40%;" aria-valuenow="40" aria-valuemin="0" aria-valuemax="100">40%</div>
    </div>
  </div>
      <form action="?page=newUser" method="post">
  <div class="form-group">
    <label for="enableStatus">Mail enabling $($upn)...</label>
        <div id="myEnableSpinner" class="spinner-border spinner-border-sm" role="status">
            <span class="sr-only">Loading...</span>
        </div>
    <input type="text" id="enableStatus" class="form-control" value="Please wait while processing..." disabled />
    <small id="userEnableHelp" class="form-text text-muted">Mail enabling the user account could take up to a minute.</small>
  </div>

  <div class="form-group" id="syncGroup">
    <label for="syncStatus">AAD Syncing $($upn)...</label>
        <div id="mySyncSpinner" class="spinner-border spinner-border-sm" role="status" style="display:none;">
            <span class="sr-only">Loading...</span>
        </div>
    <input type="text" id="syncStatus" class="form-control" value="Please wait while processing..." disabled />
    <small id="userSyncHelp" class="form-text text-muted">Delta sync could take a minute to initiate. Most warnings can be safely ignored.</small>
  </div>

  <div class="form-group" id="validateGroup">
    <label for="exoValidation">Exchange Online validation $($upn)...</label>
        <div id="myValidationSpinner" class="spinner-border spinner-border-sm" role="status" style="display:none;">
            <span class="sr-only">Loading...</span>
        </div>
    <input type="text" id="exoValidation" class="form-control" value="Please wait while processing..." disabled />
    <small id="exoValidationHelp" class="form-text text-muted">Validating the online mailbox initiates a GUID sync when the mailbox is created by Exchange Online.<br/>A failed GUID sync will leave the mailbox unable to migrate back on-prem until manual intervention.<br/>This operation can take several minutes!</small>
  </div>

  <button type="submit" class="btn btn-primary" id="createSubmit" disabled>Enable another user</button>
    </form>

    <script>
        `$(document).ready(function() {
            console.log( "ready!" );
            

            $.getJSON('queryMBXEnable.ps1?UPN=$($PoSHPost.UPN)&Group=$($PoSHPost.license)', function(json){
                const myresult = (json.result).toString();
                if (myresult === 'ok'){
                    `$('#enableStatus').attr('value', 'User successfully mail enabled and added to license group "$license"!');
                    `$('.progress-bar').css('width', '60'+'%').attr('aria-valuenow', '60').html('60'+'%');
                    `$('#myEnableSpinner').hide();       
                } else if (myresult === 'failed') {
                    `$('#enableStatus').attr('value', 'Failed to mail enabled! (user might already be enabled?)');
                    `$('.progress-bar').css('width', '100'+'%').attr('aria-valuenow', '100').html('100'+'%');
                    `$(".progress-bar").removeClass("progress-bar-striped progress-bar-animated");
                    `$(".progress-bar").addClass("bg-danger");   
                    `$('#myEnableSpinner').hide(); 
                    `$('#createSubmit').removeAttr("disabled");                    
                }

       // Show aad sync part
                
                if (myresult === 'ok'){
                    `$('#mySyncSpinner').show();
                    $.getJSON('startADSync.ps1', function(json){
                        const syncresult = (json.result).toString();
                        const output = (json.output).toString();
                        
                        if (syncresult === 'ok'){
                            var displayMsg = "Delta sync of new mailbox initiated on " + output;
                            `$('#syncStatus').attr('value', displayMsg);
                        } else if (syncresult === 'failed') {
                            var displayMsg = "Failed to initiate delta sync on " + output;
                            `$('#enableStatus').attr('value', displayMsg);
                            `$(".progress-bar").addClass("bg-warning");
                        }
                        `$('.progress-bar').css('width', '80'+'%').attr('aria-valuenow', '80').html('80'+'%');
                        `$('#mySyncSpinner').hide();
                        

                        // exo validate part
                
                        `$('#myValidationSpinner').show();
                        `$('.progress-bar').css('width', '90'+'%').attr('aria-valuenow', '90').html('90'+'%');
                        `$('#exoValidation').attr('value', 'Waiting on Exchange Online mailbox provisioning...');
                        setTimeout(function() 
                            {
                                `$('.progress-bar').css('width', '95'+'%').attr('aria-valuenow', '95').html('95'+'%');
                                `$('#exoValidation').attr('value', 'Still waiting on Exchange Online mailbox provisioning...');
                                $.getJSON('queryGUIDSync.ps1?UPN=$($PoSHPost.UPN)', function(json){
                                    const valiresult = (json.result).toString();
                                    const output = (json.message).toString();
                                    
                                    if (valiresult === 'ok'){
                                        var displayMsg = "Validation succeded with message: " + output;
                                        `$('#exoValidation').attr('value', displayMsg);
                                        `$(".progress-bar").addClass("bg-success");
                                    } else if (valiresult === 'failed') {
                                        var displayMsg = "Validation failed with message: " + output;
                                        `$('#exoValidation').attr('value', displayMsg);
                                        `$(".progress-bar").addClass("bg-warning");
                                    }
                                    `$(".progress-bar").removeClass("progress-bar-striped progress-bar-animated");
                                    `$('.progress-bar').css('width', '100'+'%').attr('aria-valuenow', '100').html('100'+'%');
                                    `$('#myValidationSpinner').hide();
                                    
                                });
                                
                            }, 30000);
                            
                     });
                     
                }

                `$('#createSubmit').removeAttr("disabled");

            });


        });
    </script>
"@