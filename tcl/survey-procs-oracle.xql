<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="survey_question_copy.create_question">      
      <querytext>
      
	    begin
		:1 := survey_question.new (
		    question_id => NULL,
		    section_id => :section_id,
                    sort_order => :new_sort_order,
                    question_text => empty_clob(),
                    abstract_data_type => :abstract_data_type,
                    presentation_type => :presentation_type,
                    presentation_alignment => :presentation_alignment,
		    presentation_options => :presentation_options,
                    active_p => :active_p,
                    required_p => :required_p,
		    context_id => :section_id,
		    creation_user => :user_id
		);
	    end;
	
      </querytext>
</fullquery>

<fullquery name="survey_question_copy.get_choice_id">
<querytext>
select survey_choice_id_sequence.nextval as choice_id from dual
</querytext>
</fullquery>

<fullquery name="get_survey_info.n_completed">
<querytext>
    		    select count(distinct survey_response.initial_user_id(response_id))
                    from 
		    survey_responses
		    where survey_id=:survey_id
</querytext>
</fullquery>


<fullquery name="survey_copy.survey_create">
<querytext>
	    begin
	        :1 := survey.new (
                    survey_id => NULL,
                    name => :name,
                    description => :description,
                    description_html_p => :description_html_p,
	            editable_p => :editable_p,
                    single_response_p => :single_response_p,
                    enabled_p => :enabled_p,
                    single_section_p => :single_section_p,
                    type => :type,
                    display_type => :display_type,
                    package_id => :package_id,
                    context_id => :package_id,
		    creation_user => :user_id
                );
    end;
</querytext>
</fullquery>

<fullquery name="survey_copy.section_create">
<querytext>
	    begin
	    :1 := survey_section.new (
	              section_id=>NULL,
		      survey_id=>:new_survey_id,
		      name=>:name,
		      description=>empty_clob(),
		      description_html_p=>:description_html_p,
		      context_id =>:new_survey_id	
		      );
	    end;
</querytext>
</fullquery>

</queryset>

