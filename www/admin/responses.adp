<master src="master">
<property name="survey_id">@survey_id;literal@</property>

<property name=title>#survey.lt_survey_name_Responses#</property>
<property name=context>@context;literal@</property>

@return_html;noquote@
<p>
@response_sentence@

<ul>
@results;noquote@
</ul>

