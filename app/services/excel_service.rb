require 'roo'

class ExcelService
  def self.read_products(input_path)
    excel = Roo::Excelx.new(input_path)
    data = []

    excel.each_row_streaming(pad_cells: true) do |row|
      product_name =
      
      row[0].to_s
      manufacturer_number = row[1].to_s
      keyword = row[2].to_s

      data << { product_name: product_name, manufacturer_number: manufacturer_number, keyword: keyword }
    end

    data
  end
  
  def self.write_products(output_path, data)
    package = Axlsx::Package.new
    workbook = package.workbook

    workbook.add_worksheet(name: 'Products') do |sheet|
      sheet.add_row(['Product Name', 'Manufacturer Number', 'Keyword', 'Cheapest Price'])

      data.each do |product|
        sheet.add_row([product[:product_name], product[:manufacturer_number], product[:keyword], product[:cheapest_price]])
      end
    end

    package.serialize(output_path)
  end
end