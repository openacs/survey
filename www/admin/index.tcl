# /www/survsimp/admin/index.tcl
ad_page_contract {
    This page is the main table of contents for navigation page 
    for simple survey module administrator

    @author philg@mit.edu
    @author nstrug@arsdigita.com
    @date 3rd October, 2000
    @cvs-id $Id$
} {

}

set package_id [ad_conn package_id]

# bounce the user if they don't have permission to admin surveys
ad_require_permission $package_id survey_admin_survey

set disabled_header_written_p 0

db_multirow surveys select_surveys {}
ad_return_template
