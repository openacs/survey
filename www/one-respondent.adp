<master>
<property name="title">Answers to @survey_name@</property>
<property name="context_bar">@context_bar@</property>

    @description@
    <p>
      <multiple name="responses">	
	<if @responses.rownum@ ne @responses:rowcount@>
          <a href="#@responses.response_id@">@responses.pretty_submission_date@</a> |
	</if>
	<else>
          <a href="#@responses.response_id@">@responses.pretty_submission_date@</a>
	</else>
      </multiple>
      <p>
        <multiple name=responses>
          <table width=100% cellpadding=2 cellspacing=2 border=0>
            <tr class="table-header" bgcolor="#e6e6e6">
              <td><a name="@responses.response_id@">Your response
            on @responses.pretty_submission_date@</a>
		<if @editable_p@ eq "t">[<a
            href="respond?survey_id=@survey_id@&response_id=@responses.response_id@">edit this response</a>]</if>
	      </td>
            </tr>
            <tr class="z_light" bgcolor="#f4f4f4">
              <td>@responses.answer_summary@</td>
            </tr>
          </table>
        </multiple>
  </html>