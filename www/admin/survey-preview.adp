<master src="master">
<property name="survey_id">@survey_id;noquote@</property>

<property name=title>#survey.lt_Preview_One_Survey_na#</property>
<property name=context>@context;noquote@</property>
<a href="@return_url@">#survey.Return#</a>
    <table border="0" cellpadding="0" cellspacing="0" width="100%">
      <form enctype="multipart/form-data" >
        <tr>
          <td class="tabledata">@description;noquote@</td>
        </tr>
	<tr>
	  <td class="tabledata"><span style="color: #f00;">*</span> #survey.lt_denotes_a_required_qu#</td>                
	</tr>
        <tr>
          <td class="tabledata"><hr noshade size="1" color="#dddddd"></td>
        </tr>
        
        <tr>
          <td class="tabledata">
	    @form_vars;noquote@
            <include src="../one_@display_type;noquote@" questions=@questions;noquote@>
            <hr noshapde size="1" color="#dddddd">
          </td>
        </tr>
        
      </form>
    </table>


