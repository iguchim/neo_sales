class PdfFormatsController < ApplicationController

  def show
    respond_to do |format|
      format.html
      format.pdf do
        # get data form db
        report_id = params[:id]
        request_id = Report.find(report_id).request_id

        request = (Form::Request.joins(:user)
                        .select('requests.*, users.name as name')
                        .where('requests.id = ?', request_id)
                        .to_a)[0]

        request_items = Form::RequestItem.joins(:request)
                        .select('request_items.*')
                        .where('request_items.request_id = ?', request_id)

        report = (Form::Report
                        .select('reports.*')
                        .where('reports.id = ?', report_id)
                        .to_a)[0]

        report_items = Form::ReportItem.joins(:report)
                        .select('report_items.*')
                        .where('report_items.report_id = ?', report_id)


        pdf = ReportPdf.new(request, request_items, report, report_items)

        send_data pdf.render,
          filename: "report.pdf",
          type: "application/pdf",
          disposition: "inline"
      end
    end
  end

end