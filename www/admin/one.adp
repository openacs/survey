<master>
<property name="survey_id">@survey_id@</property>

<property name="title">One Survey: @survey_info.name@</property>
<property name="context_bar">@context_bar@</property>
<p><a href=".">Main Survey Administration</a></p>
<font size=+1><b>@survey_info.name@</b></font> -  Created by <a href="@user_link@">@survey_info.creator_name@</a>, on @creation_date@</h2>
<table class="table-display" cellpadding=2 cellspacing=0>
	<tr class="even"><td> </td><td> This survey is <if @survey_info.enabled_p@ eq t>@survey_info.enabled_display@</if><else><span style="color: #f00;">@survey_info.enabled_display@</span></else>. - <a href="@toggle_enabled_url@">@toggle_enabled_text@</a></td></tr>

	<tr class="odd"> 
<td valign="top">Survey Name:<p>
Description: </td>
	<td >
<a href="survey-preview?survey_id=@survey_id@"><img align=right src=/graphics/preview.gif border=0 alt="Preview"></a>

	 <a href="name-edit?survey_id=@survey_id@"><img align=right src=/graphics/edit.gif border=0 alt="Edit"></a>
@survey_info.name@<p>
@survey_info.description@</td>
</tr>
	<tr class="even"><td>View Responses: </td><td >
	<a
	href="respondents?survey_id=@survey_id@">By user</a> | <a
	href="responses?survey_id=@survey_id@">Summary</a> | 
	<a href="responses-export?survey_id=@survey_id@"> CSV file</a></td>
	</tr>
	<tr class="odd"><td valign="top" rowspan="2"><nobr>Response Options: </nobr></td><td> @survey_info.single_response_display@ - [ 
	<a href="response-limit-toggle?survey_id=@survey_id@">@response_limit_toggle@</a>
	]</td></tr>
	
      
	<tr class="odd"><td><if @survey_info.editable_p@> Users may edit their responses</if><else>Users may not edit their responses</else> - [ <a
	href="response-editable-toggle?survey_id=@survey_id@">make <if
	@survey_info.editable_p@>non-</if>editable</a> ]</td></tr>

	<tr class="odd"><td>Display Options: </td><td> @survey_info.display_type@ - <list name="survey_display_types"><if @survey_info.display_type@ ne @survey_display_types:item@>[<a href="survey-display-type-edit?display_type=@survey_display_types:item@&survey_id=@survey_id@">@survey_display_types:item@</a>]</if></list></td></tr>
	
      
<tr class="odd"><td valign="top" rowspan="2">Email Options:</td><td >@notification_chunk@</td></tr>

	<tr class="odd"><td ><a href="send-mail?survey_id=@survey_id@">Send bulk
	mail</a> regarding this survey </td></tr>
	
      
	<tr><td></td><td >
	
      <tr class="even">
	<td>Extreme Actions: </td><td >
	<a href="survey-delete?survey_id=@survey_id@">Delete this survey</a> - Removes all questions and responses<br>
	<a href="survey-copy?survey_id=@survey_id@">Copy this survey</a> - Lets you use this survey as a template to create a new survey.
	</td></tr>
</table>
<br />

<h3>Questions</h3>
<table cellspacing=0>
<if @questions:rowcount@ eq 0>
    <tr class="odd">
  </else>
<td></td><td><a href="question-add?section_id=@survey_info.section_id@">add new question</a></tr></tr>
</if>
<multiple name="questions">

  <if @questions.rownum@ odd>
    <tr class="odd">
  </if>
  <else>
    <tr class="even">
  </else>

<td valign="top">@questions.rownum@.  <a name="@questions.sort_order@"></a></td>

<td><a	href="question-modify?question_id=@questions.question_id@&section_id=@section_id@&survey_id=@survey_id@"><img src=/graphics/edit.gif border=0 alt="Edit"></a>
<if @questions.active_p@ eq "f"><span style="color: #f00;">[inactive]</span></if>
<a href="question-copy?question_id=@questions.question_id@&sort_order=@questions.sort_order@"><img src="/graphics/copy.gif" border="0" alt="Copy"></a>
<a href="question-add?section_id=@section_id@&after=@questions.sort_order@"><img src="/graphics/new.gif" border="0" alt="Add New"></a><img src="/graphics/spacer.gif" border="0" alt="" width="10">
<if @questions.rownum@ lt @questions:rowcount@ ><a
	  href="question-swap?section_id=@section_id@&survey_id=@survey_id@&sort_order=@questions.sort_order@&direction=down"><img src="/graphics/down" border="0" alt="Move Down"></a></if><if @questions.rownum@ gt 1><a
	  href="question-swap?section_id=@section_id@&survey_id=@survey_id@&sort_order=@questions.sort_order@&direction=up"><img src="/graphics/up.gif" border="0" alt="Move Up"></a></if><a href="question-delete?question_id=@questions.question_id@&survey_id=@survey_id@"><img src="/graphics/delete.gif" border="0" alt="Delete"></a></td></tr>

  <if @questions.rownum@ odd>
    <tr class="odd">
  </if>
  <else>
    <tr class="even">
  </else>
<td colspan="3">
  <blockquote>@questions.question_display@</blockquote>
</td></tr>
<if @questions.rownum@ eq @questions:rowcount@>
  <if @questions.rownum@ odd>
    <tr class="even">
  </if>
  <else>
    <tr class="odd">
  </else>
<td></td><td><a href="question-add?section_id=@survey_info.section_id@">add new question</a></tr></tr>
</if>
</multiple>
</table>      
