<master src="master">
<property name="survey_id">@survey_id@</property>

<property name=title>Preview One Survey: @name@</property>
<property name=context_bar>@context_bar@</property>
<a href="@return_url@">Return</a>
    <table border="0" cellpadding="0" cellspacing="0" width="100%">
      <form enctype="multipart/form-data" >
        <tr>
          <td class="tabledata">@description@</td>
        </tr>
	<tr>
	  <td class="tabledata"><span style="color: #f00;">*</span> denotes a required question</td>                
	</tr>
        <tr>
          <td class="tabledata"><hr noshade size="1" color="#dddddd"></td>
        </tr>
        
        <tr>
          <td class="tabledata">
	    @form_vars@
            <include src="../one_@display_type@" questions=@questions@>
            <hr noshapde size="1" color="#dddddd">
          </td>
        </tr>
        
      </form>
    </table>
