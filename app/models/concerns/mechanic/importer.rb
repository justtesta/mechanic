class Mechanic < ApplicationRecord
  class Importer

    class ImportRow
      attr_accessor :row, :index, :error_messages
      attr_accessor :province, :province_cd, :city, :city_cd, :district, :district_cd, :address, :nickname, :mobile
      attr_accessor :unique_id, :description

      def initialize row, index
        @error_messages = []
        @row = row
        @index = index
      end

      def parse
        @province = row[0].value.gsub("省", "") rescue nil
        @province_cd = Mechanic.provinces[@province]
        unless @province_cd
          @error_messages << "未知省份：“#{@province}”"
        end

        @city = row[1].value.gsub("市", "") rescue nil
        @city_cd = Mechanic.cities[@city]
        unless city_cd
          @error_messages << "未知城市：“#{@city}”"
        end

        @district = row[2].value
        @district_cd = Mechanic.districts[@district]
        unless district_cd
          if @district==""
          @error_messages << "未知区县3：“#{@district}”"
        else
          @error_messages << "未知区县2：“#{@district}”"
          end
        end
        if @district==""
           @error_messages << "未知区县5：“#{row[2].value}”"
         else
            @error_messages << "未知区县2：“#{row[2].value}”"
          end
           
        
        if @district==""
          @address = row[2].value
          @nickname = row[3].value
          @mobile = row[4].value
          @unique_id = row[5].value
          @description = row[6].value
        else
          @address = row[3].value
          @nickname = row[4].value
          @mobile = row[5].value
          @unique_id = row[6].value
          @description = row[7].value
        end

      
        
        sleep 0.3
        success?
      end

      def create_record
        mechanic = User.new({
          role: :mechanic,
          gender: :male,
          address: address,
          nickname: nickname,
          mobile: mobile,
          mechanic_attributes: {
            province_cd: province_cd,
            city_cd: city_cd,
            district_cd: district_cd,
            unique_id:unique_id,
            description:description
          }
        })
        mechanic.skip_send_verification_code
        unless mechanic.save
          @error_messages.concat mechanic.errors.full_messages.uniq
        end

        success?
      end

      def success?
        @error_messages.empty?
      end
    end

    attr_accessor :failed_rows, :success_count, :error_message

    def initialize file
      @failed_rows = []
      @success_count = 0

      xlsx = Roo::Spreadsheet.open(file)

      xlsx.each_row_streaming.each_with_index do |row, index|
        import_row = ImportRow.new row, index
        unless import_row.parse
          @failed_rows << import_row
          next
        end

        if import_row.create_record
          @success_count += 1
        else
          @failed_rows << import_row
        end
      end
    rescue ArgumentError
      @error_message = "文件格式错误，请确认您上传的Excel文件"
    end

    def success?
      !@error_message
    end

    def each_failed_row &block
      @failed_rows.each(&block)
    end
  end
end
