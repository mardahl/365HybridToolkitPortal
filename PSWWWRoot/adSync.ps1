@"
  <div class="starter-template">
    <h1>Azure AD Connect</h1>
    <p class="lead">Trigger delta sync</p>
    <div class="progress">
      <div class="progress-bar progress-bar-striped progress-bar-animated" role="progressbar" style="width: 0%;" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100">0%</div>
    </div>
  </div>


      <form action="?page=adSync" method="post">
  <div class="form-group">
    <label for="userEnable">AAD Sync Status:</label>
    <input type="text" id="enableStatus" class="form-control" value="Ready to initiate sync." disabled />
    <small id="userEnableHelp" class="form-text text-muted">Delta sync can take several minutes. An existing sync will block the command from completing..</small>
  </div>

  <button type="submit" class="btn btn-primary" id="createSubmit">Initiate delta sync</button>
    </form>

    <script>
        `$(document).ready(function() {
            console.log( "ready!" );

                `$("form").submit(function(e){
                    //prevent form form actually submitting to another page
                    e.preventDefault();

                    `$('.progress-bar').css('width', '50'+'%').attr('aria-valuenow', '50').html('50'+'%');
                    `$('#enableStatus').attr('value', 'Sending sync command. Please wait...');
                    `$('#createSubmit').attr("disabled", true);

                    $.getJSON('startADSync.ps1', function(json){
                        const myresult = (json.result).toString();
                        const output = (json.output).toString();
                        
                            if (myresult === 'ok'){
                                var displayMsg = "Delta sync initiated on " + output;
                                `$('#enableStatus').attr('value', displayMsg);
                                `$('.progress-bar').css('width', '100'+'%').attr('aria-valuenow', '100').html('100'+'%');
                                `$(".progress-bar").removeClass("progress-bar-striped progress-bar-animated");
                                `$(".progress-bar").addClass("bg-success");

                            } else if (myresult === 'failed') {
                                var displayMsg = "Failed to initiate delta sync on " + output;
                                `$('#enableStatus').attr('value', displayMsg);
                                `$('.progress-bar').css('width', '100'+'%').attr('aria-valuenow', '100').html('100'+'%');
                                `$(".progress-bar").removeClass("progress-bar-striped progress-bar-animated");
                                `$(".progress-bar").addClass("bg-warning");

                            }


                    });
                });
        });
    </script>
"@