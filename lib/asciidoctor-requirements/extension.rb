require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'
require 'yaml'

# An asciidoctor extension that transforms a yaml block in a formatted requirement
module AsciidoctorRequirements
    module Asciidoctor

        class RequirementBlock < ::Asciidoctor::Extensions::BlockProcessor
            use_dsl
            named :requirement
            on_context :example
            parse_content_as :raw

            def process(parent, reader, attrs)
                req_yaml = req_parse_yaml(reader)

                req_validate_inputs(parent, req_yaml)

                req_create_section(parent, req_yaml, attrs)                           
                req_create_description(parent, req_yaml, attrs)
                req_create_tabs_table(parent, req_yaml, attrs)
                req_create_rationale(parent, req_yaml, attrs)
                req_create_break(parent)
               
                return parent
            end

            # Read yaml from block
            def req_parse_yaml(reader)
                raw_data = reader.readlines.join("\n")

                begin
                    yaml = YAML.load(raw_data)
                rescue => e
                    puts "\n\n"
                    puts "!!!!!!!!!!!!!!!!!!!!!!!!!!"
                    puts "!!! YAML parsing error !!!"
                    puts "!!!!!!!!!!!!!!!!!!!!!!!!!!\n"
                    puts "e.message: " + e.message + "\n\n"

                    puts "Malformed yaml in loaded data:\n////////\n" + raw_data + "\n////////\n\nUsual errors:\n\t* Tabulations are not allowed. Use spaces instead.\n\n\n" 
                    raise e
                end

                return yaml
            end

            # Validate yaml has mandatory elements
            def req_validate_inputs(parent, yaml)
                if parent.document.attributes["reqprefix"].nil?
                    raise "reqprefix missing in document.\n" + req_usage() 
                end
                if yaml["title"].nil?
                    raise "Title missing in requirement yaml.\n" + req_usage() 
                end

                if yaml["rev"].nil?
                    raise "Revision missing in requirement yaml.\n" + req_usage() 
                end

                if yaml["id"].nil?
                    raise "id missing in requirement yaml.\n" + req_usage()
                end

                if yaml["description"].nil?
                    raise "Description missing in requirement yaml.\n" + req_usage() 
                end
            end

            # Create subsection 
            def req_create_section(parent, yaml, attrs)
                section_title = String(parent.document.attributes["reqprefix"] + "_" +yaml["id"] + "_" + yaml["rev"] + " : " + yaml["title"])

                parent << create_section(parent, section_title, {})
            end

            # Create description block
            def req_create_description(parent, yaml, attrs)
                description_text = "[.lead]\n" +  yaml["description"]

                parse_content(parent, description_text, {})
            end

            # Create rationale block, if rationale element is present in yaml
            def req_create_rationale(parent, yaml, attrs)
                if yaml["rationale"].nil?
                    return
                end

                table_delimiter = "|==="
                rationale = "[cols='.^1,6', frame=none, grid=none]\n" + table_delimiter + "\ns|Rationale a|[.rationale]\n" + yaml["rationale"].strip + "\n" + table_delimiter

                parse_content(parent, rationale, {})
            end

            # Create tags block, if tags element is present in yaml
            def req_create_tabs_table(parent, yaml, attrs)
                if yaml["tags"].empty?
                    return
                end

                tag_lines = ""
                table_delimiter = "|==="

                yaml["tags"].each do |k, v|
                    tag_lines += "|" + k + "|" + v + "\n"
                end

                tag_lines = "[cols='.^1,6']\n" + table_delimiter + "\n" + tag_lines + table_delimiter

                parse_content(parent, tag_lines, {})
            end

            # Create line separator block
            def req_create_break(parent)
                parse_content(parent, "'''", {})
            end

            # Return usage string
            def req_usage()
                usage = '
                USAGE : 
                :reqprefix: PREFIX

                [requirement]
                ====
                id: "0170"
                rev: a
                status: valid
                title: Document Capability
                description: The STRS platform provider shall describe, in the HID document, the reconfigurability behavior and capability of each reconfigurable component. 
                rationale: |
                    Waveform developers need to know the features and limitations of the platform for their applications.
                    Once the radio has been procured, NASA has the knowledge to procure or produce new or additional modules using HID information.
                    Also, future module replacement or additions will be possible without designing a new platform.
                
                
                tags:
                    key1: value1
                    key2: value2
                ====
                
                '
                return usage
            end
        end
    end
end