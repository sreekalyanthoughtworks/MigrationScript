#!/bin/bash

### Main script starts here
##Author :-- Sreekalyan Bapatla
Show_Menus()
{
                normal=`echo "\033[m"`
                menu=`echo "\033[36m"` #Blue
                number=`echo "\033[33m"` #yellow
                bgred=`echo "\033[41m"`
                fgred=`echo "\033[31m"`
                fgreen=`echo "\033[0;32m"` #Green
                printf "\n"
                
                echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            printf " ${menu}                    ${fgred}Welcome to Migration maker script${normal}         \n"
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                printf "${menu}**${number} 1)${menu} Adding Parent concepts to OpenMrs ${normal}\n"
                printf "${menu}**${number} 2)${menu} Adding Child  concepts to OpenMrs ${normal}\n"
                printf "${menu}**${number} 3)${menu} Adding concepts to Numeric Table along with the units${normal}\n"
                printf "${menu}**${number} 4)${menu} Adding Help text to Concepts${normal}\n"
                printf "${menu}**${number} 5)${menu} Adding Reference Term Source and Codes ${normal}\n"
                printf "${menu}**${number} 6)${menu} Mapping the child concepts with parent concepts ${normal}\n"
                printf "${menu}**${number} 7)${menu} Query to check the child concepts in OPENMRS ${normal}\n"
                printf "${menu}**${number} 8)${menu} Enter ${fgred} x ${normal} to exit ${normal}\n"
                printf "${menu}***********************************************************************************${normal}\n"
                printf "Please enter a menu option and enter or ${fgred}x to exit. ${normal}"
                read option

}
formating_the_parent_concepts()
{

                if [ ! -d ./ParentConcepts ]; then
                mkdir -p ./ParentConcepts;
                fi

                rm ./ParentConcepts/ParentConcepts.txt 2>/dev/null
                touch ./ParentConcepts/ParentConcepts.txt 2>/dev/null

                rm ./ParentConcepts/Trimmed_Parentconcepts.txt ./ParentConcepts/Unique_Parentconcepts.txt ./ParentConcepts/Parentconcepts_Withquotes.txt ./ParentConcepts/ParentconceptMigrationformat.txt 2>/dev/null
                touch ./ParentConcepts/Trimmed_Parentconcepts.txt ./ParentConcepts/Unique_Parentconcepts.txt ./ParentConcepts/Parentconcepts_Withquotes.txt ./ParentConcepts/ParentconceptMigrationformat.txt 2>/dev/null

                printf "\n%5s ${fgreen}Make sure you have the concepts updated that are to be added in the input file ${fgred} `pwd`/ParentConcepts/parentconcepts.txt file and press enter\n"
                read -n1 G

                # Trim the spaces
                #awk '{$1=$1};1'

                cat ./ParentConcepts/ParentConcepts.txt | while read line
                do
                echo "$line" | xargs >> ./ParentConcepts/Trimmed_Parentconcepts.txt
                done

                ## Remove Duplicates.
                cat ./ParentConcepts/Trimmed_Parentconcepts.txt | sort  | uniq > ./ParentConcepts/Unique_Parentconcepts.txt
                ## Keep them in double quotes.
                cat ./ParentConcepts/Unique_Parentconcepts.txt | while read line
                do
                echo "\"$Prefix, $line\",\"$line\"" >> ./ParentConcepts/Parentconcepts_Withquotes.txt
                done
}
formating_the_child_concepts()
{
                if [ ! -d ./ChildConcepts ]; then
                mkdir -p ./ChildConcepts;
                fi

                rm ./ChildConcepts/ChildConcepts.txt ./ChildConcepts/Trimmed_Childconcepts.txt ./ChildConcepts/Unique_Childconcepts.txt ./ChildConcepts/Childconcepts_WithQuotes.txt 2>/dev/null
                touch rm ./ChildConcepts/ChildConcepts.txt ./ChildConcepts/Trimmed_Childconcepts.txt ./ChildConcepts/Unique_Childconcepts.txt ./ChildConcepts/Childconcepts_WithQuotes.txt
                
                printf "\n%5s ${fgreen}Make sure you have the concepts updated that are to be added in the input file ${fgred} `pwd`/ChildConcepts/Childconcepts.txt and press enter\n"
                read -n1 G

                # Trim the spaces
                #awk '{$1=$1};1'
                cat ./ChildConcepts/ChildConcepts.txt | while read concepts
                do
                echo "$concepts" | xargs >>./ChildConcepts/Trimmed_Childconcepts.txt
                done
                ## Remove Duplicates.
                cat ./ChildConcepts/trimmed_childconcepts.txt | sort |  uniq > ./ChildConcepts/Unique_Childconcepts.txt
                ## Keep them in double quotes.
                cat ./ChildConcepts/Unique_Childconcepts.txt | while read line
                do
                echo "\"$line\"","\"$line\"" >> ./ChildConcepts/Childconcepts_WithQuotes.txt
                done
}
add_parent_concept()
{

                #### Adding the Data Type and Class and is section fields
                printf "\n %5s ${fgreen}Enter the desired ${fgred} Datatype ${normal}: "
                read Datatype
                printf "\n %5s ${fgreen} Enter the desired ${fgred} Class ${normal}:  "
                read Class
                printf "\n %5s ${fgreen} Is the concept a ${fgred} Concept set ${normal} input ${fgred} true ${normal} or ${fgred} false:"
                read Bool
                #### Adding the prefix and suffix
                sed "s~^~call add_concept(@concept_id,@concept_short_id,@concept_full_id,~;
                s~$~,\"$Datatype\",\"$Class\",$Bool);~" ./ParentConcepts/Parentconcepts_Withquotes.txt > ./ParentConcepts/ParentconceptMigrationformat.txt

                printf "\n %5s ${fgreen} Check the output in  ${fgred}   *************`pwd`/ParentConcepts/ParentconceptMigrationformat.txt ********** ${fgred}\n"
}
add_child_concept()
{               
                rm ./ChildConcepts/ChildconceptMigrationformat.txt 2>/dev/null
                touch ./ChildConcepts/ChildconceptMigrationformat.txt 2>/dev/null

                
                #### Adding the Data Type and Class and is section fields
                printf "\n %5s ${fgreen}Enter the desired ${fgred} Datatype ${normal}: "
                read Datatype
                printf "\n %5s ${fgreen} Enter the desired ${fgred} Class ${normal}: "
                read Class
                printf "\n %5s ${fgreen} Is the concept a ${fgred} Section ${normal} input true or false:"
                read Bool
                #### Adding the prefix and suffix
                sed "s~^~call add_concept(@concept_id,@concept_short_id,@concept_full_id,~;
                s~$~,\"$Datatype\",\"$Class\",$Bool);~" ./ChildConcepts/Childconcepts_WithQuotes.txt > ./ChildConcepts/ChildconceptMigrationformat.txt

                 printf "\n %5s ${fgreen} Check the output in  ${fgred}   *************`pwd`/ChildConcepts/ChildconceptMigrationformat.txt ********** ${fgred}\n"
}
add_numeric_concept()
{           
            if [ ! -d ./NumericConcepts ]
            then
            mkdir -p ./NumericConcepts
            fi

            rm ./NumericConcepts/MigrationFormat.txt 2>/dev/null
            touch ./NumericConcepts/MigrationFormat.txt 2>/dev/null

            n=1
            until [ $n -ge 2 ]
            do
            printf "\n %5s ${fgreen} Enter the ${fgred} Concept ${normal} name: "
            read Concept
            printf "\n %5s ${fgreen} Enter the ${fgred} Units, if not then press Enter: "
            read Units
            if [ -z "$Units" ]
                then
                    printf "INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision)" >> ./NumericConcepts/MigrationFormat.txt
                    printf "VALUES ((select concept_id from concept_name where name = \"$Concept\" and concept_name_type = 'FULLY_SPECIFIED'  and locale = 'en'  and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,\"\",1,1);" >> ./NumericConcepts/migrationformat.txt
                else
                    echo "INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision)" >> ./NumericConcepts/MigrationFormat.txt
                    echo "VALUES ((select concept_id from concept_name where name = \"$Concept\" and concept_name_type = 'FULLY_SPECIFIED'  and locale = 'en'  and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,\"$Units\",1,1);" >> ./NumericConcepts/migrationformat.txt
             fi
            echo "Do you have more Numeric concepts, choose 1 or 2"
            echo "1.Yes"
            echo "2.No"
            read value
            n=$value
            done
}
add_concept_description()
{           
           if [ ! -d ./ConceptDescription ]
            then
            mkdir -p ./ConceptDescription
            fi

           rm ./ConceptDescription/DescriptionMigrationformat.txt 2>/dev/null
           touch ./ConceptDescription/DescriptionMigrationformat.txt 2>/dev/null
           n=1
           until [ $n -ge 2 ]
           do
           printf "\n %10s ${fgred} Enter the ${fgred} Concept ${normal}: "
           read Concept_De
           printf "\n %10s ${fgreen} Enter the ${fgred} Description ${normal}, if not then press Enter:  "
           read Description
           echo "INSERT INTO concept_description (concept_id,description,locale,creator,date_created,changed_by,date_changed,uuid)" >> ./ConceptDescription/DescriptionMigrationformat.txt
           echo "VALUES ((select concept_id from concept_name where name = \"$Concept_De\" and concept_name_type = 'FULLY_SPECIFIED' and locale = 'en' and voided = 0),\"$Description\",'en',1,now(),NULL,NULL,uuid());" >> ./ConceptDescription/DescriptionMigrationformat.txt
           echo "Do you have more concepts to add description, choose 1 or 2"
           echo "1.Yes"
           echo "2.No"
           read value
           n=$value
           done
}
add_reference_term_code_mapping()
{           
           if [ ! -d ./ReferenceTerm ]
            then
            mkdir -p ./ReferenceTerm
           fi


           rm ./ReferenceTerm/Existing_Mapping.txt  ./ReferenceTerm/Reference_Term_Codemapping_Migration.txt ./ReferenceTerm/Non_Existing_Mapping.txt 2>/dev/null
           touch ./ReferenceTerm/Existing_Mapping.txt  ./ReferenceTerm/Reference_Term_Codemapping_Migration.txt ./ReferenceTerm/Non_Existing_Mapping.txt 2>/dev/null

           rm ./ReferenceTerm/Reference_Code_Mapping_Quotes.txt ./ReferenceTerm/Reference_Term_Mapping_Singleline.txt 2>/dev/null
           touch ./ReferenceTerm/Reference_Code_Mapping_Quotes.txt ./ReferenceTerm/Reference_Term_Mapping_Singleline.txt 2>/dev/null

           rm ./ReferenceTerm/Reference_Code_Mapping_Onlycodes.txt  2>/dev/null
           touch ./ReferenceTerm/Reference_Code_Mapping_Onlycodes.txt  2>/dev/null

           printf "\n %10s ${fgred} Enter the ${fgred} Reference Term Source ${normal} name:"
           read rts
           export RTS=$rts
           
           printf "\n%5s ${fgreen}Make sure you have the concepts updated that are to be added in the input file ${fgred} `pwd`/ReferenceTerm/Existing_Mapping.txt and  `pwd`/ReferenceTerm/Non_Existing_Mapping.txt \n"
           read -n1 G

           #####keeping the concepts into Double Quote format for change set creation"
            cat ./ReferenceTerm/Non_Existing_Mapping.txt | while read line
            do
            echo $line | awk -F~ ' {print $2}' >>./ReferenceTerm/Reference_Code_Mapping_Onlycodes.txt
            done
            ####keeping the output in single line
            cat ./ReferenceTerm/Reference_Code_Mapping_Onlycodes.txt | while read line
            do
            echo \"$line\", | awk '{printf "%s",$0} END {print ""}' >>./ReferenceTerm/Reference_Code_Mapping_Quotes.txt
            done

            cat ./ReferenceTerm/Reference_Code_Mapping_Quotes.txt | awk '{printf "%s",$0} END {print ""}' >> ./ReferenceTerm/Reference_Term_Mapping_Singleline.txt

           echo "
           <changeSet id=\"IRAQ_CONFIG_`date +%Y%m%d%H%M``date +%s | tail -c 2`\" author=\"SreeKalyan\">
                <preConditions onFail=\"MARK_RAN\">
                    <sqlCheck expectedResult=\"0\">
                        select
                        count(*)
                        From
                        concept_reference_term
                        where \`code\` in
                        (`sed "s/,$//" ./ReferenceTerm/Reference_Term_Mapping_Singleline.txt`)
                        and retired = 0
                        and concept_source_id = (
                        select concept_source_id from concept_reference_source where name = \"$RTS\"  and retired =0
                        );
                    </sqlCheck>
                </preConditions>

                <comment>Adding codes to $rts </comment>" >> ./ReferenceTerm/Reference_Term_Codemapping_Migration.txt

                 echo "SELECT concept_source_id INTO @source_id FROM concept_reference_source where name = \"$rts\"
                 and retired =0;" >> ./ReferenceTerm/Reference_Term_Codemapping_Migration.txt

                 cat ./ReferenceTerm/Existing_Mapping.txt  | while read line
                 do
                 concept_reference_source_name=`echo "$line" | awk -F~ ' { print $1}'`
                 concept_reference_source_code=`echo "$line" |  awk -F~ ' { print $2}'`
                 echo "call CREATE_REFERENCE_MAPPING_$RTS(\"$concept_reference_source_name\",\"$concept_reference_source_code\");" >> ./ReferenceTerm/Reference_Term_Codemapping_Migration.txt
                 done

                 cat ./ReferenceTerm/Non_Existing_Mapping.txt  | while read line
                 do
                 concept_reference_source_name=`echo "$line" | awk -F~ ' { print $1}'`
                 concept_reference_source_code=`echo "$line" | awk -F~ ' { print $2}'`
                 echo "INSERT INTO concept_reference_term (creator,code,concept_source_id,uuid,date_created) VALUES
                  (4,\"$concept_reference_source_code\",@source_id,uuid(),now());" >> ./ReferenceTerm/Reference_Term_Codemapping_Migration.txt
                 echo "call CREATE_REFERENCE_MAPPING_$RTS(\"$concept_reference_source_name\",\"$concept_reference_source_code\");" >> ./ReferenceTerm/Reference_Term_Codemapping_Migration.txt
                 done

}
mapping_parent_child_concepts()
{           
            if [ ! -d ./ParentChildMapping ]
            then
            mkdir -p ./ParentChildMapping
           fi



            rm ./ParentChildMapping/Parent_Child_Mapping_Migration.txt ./ParentChildMapping/Parent_Child_Mapping_Input.txt ./ParentChildMapping/Trimmed_Parent_Child_Mapping.txt ./ParentChildMapping/Remove_Ceil_From_Concept.txt ./ParentChildMapping/Parent_Child_Mapping_Quotes.txt 2>/dev/null
            touch ./ParentChildMapping/Parent_Child_Mapping_Migration.txt ./ParentChildMapping/Parent_Child_Mapping_Input.txt ./ParentChildMapping/Trimmed_Parent_Child_Mapping.txt ./ParentChildMapping/Remove_Ceil_From_Concept.txt ./ParentChildMapping/Parent_Child_Mapping_Quotes.txt 2>/dev/null
            
            rm ./ParentChildMapping/Parent_Child_Mapping_Singleline.txt ./ParentChildMapping/Remove_Ceil_Forchangeset_Concept.txt ./ParentChildMapping/Parent_Child_Mapping_Input_trimmed.txt 2>/dev/null
            touch ./ParentChildMapping/Parent_Child_Mapping_Singleline.txt ./ParentChildMapping/Remove_Ceil_Forchangeset_Concept.txt ./ParentChildMapping/Parent_Child_Mapping_Input_trimmed.txt 2>/dev/null
            
            printf "\n %10s ${fgred} Enter the ${fgred} Parent concept ${normal} name: "
            read parent_concept_name
            printf "\n %10s ${fgred} Enter the Parent concept ${fgred} PREFIX ${normal} name: "
            read prefix
            printf "\n %10s ${fgred} Enter the ${fgred}child concepts values to be mapped in the `pwd`/ParentChildMapping/Parent_Child_Mapping_Input.txt and press enter: "
            read -n1 G

            ## Remove Ceilcoded values from concepts.
            cat ./ParentChildMapping/Parent_Child_Mapping_Input.txt | while read line
            do
            echo $line | sed 's/(.*//g' >> ./ParentChildMapping/Remove_Ceil_Forchangeset_Concept.txt
            done

            # Trim the spaces
                #awk '{$1=$1};1'
            cat ./ParentChildMapping/Remove_Ceil_Forchangeset_Concept.txt | while read concepts
            do
            echo "$concepts" | xargs >> ./ParentChildMapping/Parent_Child_Mapping_Input_trimmed.txt
            done

            #####keeping the concepts into Double Quote format for change set creation"
            cat ./ParentChildMapping/Parent_Child_Mapping_Input_trimmed.txt | while read line
            do
            echo "\"$line\"," | awk '{printf "%s",$0} END {print ""}' >>./ParentChildMapping/Parent_Child_Mapping_Quotes.txt
            done
            ####keeping the output in single line

            cat ./ParentChildMapping/Parent_Child_Mapping_Quotes.txt | awk '{printf "%s",$0} END {print ""}' >> ./ParentChildMapping/Parent_Child_Mapping_Singleline.txt
            echo "

                <changeSet id=\"Malawi_CONFIG_`date +%Y%m%d%H%M``date +%s | tail -c 2`\" author=\"SreeKalyan\">
                <preConditions onFail=\"MARK_RAN\">
                <sqlCheck expectedResult=\"0\">
                select count(*) from concept_answer ca
                join
                concept_name cn
                on ca.concept_id = cn.concept_id
                where ca.answer_concept IN (select concept_id from concept_name where name IN
                (`sed "s/,$//" ./ParentChildMapping/Parent_Child_Mapping_Singleline.txt`)
                and concept_name_type = \"FULLY_SPECIFIED\")
                AND
                cn.concept_id IN (select concept_id from concept_name where name = \"$prefix, $parent_concept_name\");
                </sqlCheck>
                </preConditions>
                <comment>Adding Answers to "$parent_concept_name"</comment>
                <sql>"  >> ./ParentChildMapping/Parent_Child_Mapping_Migration.txt
            echo "select concept_id into @concept_id from concept_name where name = \"$prefix, $parent_concept_name\" and
            concept_name_type = 'FULLY_SPECIFIED' and locale = \"en\" and voided = 0;" >> ./ParentChildMapping/Parent_Child_Mapping_Migration.txt
            ##Trim the spaces
            cat ./ParentChildMapping/Parent_Child_Mapping_Input.txt | while read line
            do
                echo "$line" | xargs >> ./ParentChildMapping/Trimmed_Parent_Child_Mapping.txt
            done
            ## Remove Duplicates.
            cat ./ParentChildMapping/Trimmed_Parent_Child_Mapping.txt | uniq > ./ParentChildMapping/Uniq_Parent_Child_mapping.txt
            ## Keep them in double quotes.
            cat ./ParentChildMapping/Uniq_Parent_Child_mapping.txt | while read line
                do
                    echo $line | sed 's/&.*//g' >> ./ParentChildMapping/Remove_Ceil_From_Concept.txt
                done
            counter=1
            linecount=`cat ./ParentChildMapping/Remove_Ceil_From_Concept.txt | wc -l`
            while [ "$counter" -le "$linecount" ]
                do
                    echo "set @child${counter}_concept_id = 0;" >>./ParentChildMapping/Parent_Child_Mapping_Migration.txt
                    let counter++
                done
            counter=1
            cat ./ParentChildMapping/Remove_Ceil_From_Concept.txt | while read line
                do
                    echo "select concept_id into @child${counter}_concept_id from concept_name where name =\"$line\" and concept_name_type = 'FULLY_SPECIFIED' and locale = 'en' and voided = 0;" >>./ParentChildMapping/Parent_Child_Mapping_Migration.txt
                    let counter++
                done
            counter=1
            while [ "$counter" -le "$linecount" ]
                do
                    echo "call add_concept_answer(@concept_id, @child${counter}_concept_id, $counter);" >>./ParentChildMapping/Parent_Child_Mapping_Migration.txt
                    let counter++
                done
            echo "</sql>"  >>./ParentChildMapping/Parent_Child_Mapping_Migration.txt
            echo "</changeSet>"  >>./ParentChildMapping/Parent_Child_Mapping_Migration.txt

            echo "***************************************************************************************************************************************************************************************" >>    ./Parent_Child_Mapping_Final_Migration.txt

            cat ./ParentChildMapping/Parent_Child_Mapping_Migration.txt >> ./ParentChildMapping/Parent_Child_Mapping_Final_Migration.txt

}
check_childconcepts_openmrs()
{

                rm ./trimmed_childconcepts_openmrs.txt ./unique_childconcepts_openmrs.txt ./removeceilcode_fromconcept.txt ./Doublequote_openmrs.txt ./Querytocheckraw_openmrs.txt ./Querytocheck_openmrs.txt ./already_childconcepts_openmrs.txt 2>/dev/null
                touch ./trimmed_childconcepts_openmrs.txt ./unique_childconcepts_openmrs.txt ./removeceilcode_fromconcept.txt ./Doublequote_openmrs.txt ./Querytocheckraw_openmrs.txt ./Querytocheck_openmrs.txt ./already_childconcepts_openmrs.txt
                rm ./trimmedremovedceilcode_childconcepts_openmrs.txt 2>/dev/null
                touch ./trimmedremovedceilcode_childconcepts_openmrs.txt
                printf "\n %10s ${fgred} Enter the ${fgred} Concepts in the text file ${normal} childconcepts_openmr..txt and press enter ${fgred} :  "
                read -n1 G

                  ## Remove Ceilcoded values from concepts.
                cat ./childconcepts_openmrs.txt | while read line
                    do
                    echo $line | sed 's/([0-9].*//g' >> ./removeceilcode_fromconcept.txt
                done
                  # Trim the spaces
                #awk '{$1=$1};1'
                cat ./removeceilcode_fromconcept.txt | while read concepts
                do
                echo "$concepts" | xargs >> ./trimmed_childconcepts_openmrs.txt
                done

                ## Remove Duplicates.
                sort ./trimmed_childconcepts_openmrs.txt | sort uniq  > ./unique_childconcepts_openmrs.txt

                cat ./unique_childconcepts_openmrs.txt | while read line
                do
                echo "\"$line\"," | awk '{printf "%s",$0} END {print ""}' >> ./Doublequote_openmrs.txt
                done

                ### Query for SQL
                cat ./Doublequote_openmrs.txt | awk '{printf "%s",$0} END {print ""}' >> ./Querytocheckraw_openmrs.txt
                sed "s~^~select DISTINCT name from concept_name where name in(~;
                s/,$//; s~$~);~" ./Querytocheckraw_openmrs.txt > ./Querytocheck_openmrs.txt


                printf "\n %5s ${fgred} Enter the ${fgred} Already existing concepts in ${normal} childconcepts_openmrs/already_childconcepts_openmrs.txt  and press enter ${fgred}"
                read -n1 G
                rm ./childconcepts.txt
                touch ./childconcepts.txt
                join -v1 -v2 <(cat ./removeceilcode_fromconcept.txt) <(cat ./already_childconcepts_openmrs.txt) > ./childconcepts.txt
}

# Main Execution starts here
Show_Menus
while :
    do
        case $option in

            1)  
                
                printf "\n %10s ${fgreen} Enter the prefix of the parent concepts:"
                read Prefix
                formating_the_parent_concepts
                add_parent_concept
                Show_Menus
                ;;

            2)  
                formating_the_child_concepts
                add_child_concept
                Show_Menus
                ;;
            3)
                add_numeric_concept
                Show_Menus
                ;;
            4)
                add_concept_description
                Show_Menus
                ;;
            5)
                add_reference_term_code_mapping
                Show_Menus
                ;;
            6)
                mapping_parent_child_concepts
                Show_Menus
                ;;
            7)
                check_childconcepts_openmrs
                Show_Menus
                ;;
            x)
                exit;
                ;;
        esac
    done
