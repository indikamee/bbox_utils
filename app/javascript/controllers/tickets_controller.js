import { Controller } from "@hotwired/stimulus"
import 'jquery';
import "datatables.net";
import 'dataTables.select';

import * as tu from 'lib/table_utils'

// Connects to data-controller="controller"
export default class extends Controller {
  static targets = ["ticketsTable"]
  connect() {
    console.log("Tickets Controller connected.")
  }
  async initialize() {
    this.initTable()
  }

  initTable(){
    //console.log("Init table")

    if (!this.ticketsTableTarget) {
      return;
    }

    const tableElement = $(this.ticketsTableTarget); // Ensure it's a jQuery object
    
    const tableId = tableElement.attr('id');
    if ($.fn.dataTable.isDataTable(tableElement)) {
      tableElement.DataTable().destroy();
    }
    var table = tableElement.dataTable({
      pageLength: tu.getTableRowsToShow(tableId),
      initComplete: function(settings, json) {
        tu.addFilters(this.api(), [1,3,,5,6,7]);
      }
    });
    $('.dataTables_filter input,select').addClass('form-control');
    tableElement.DataTable().on('length.dt', tu.storeTableRowsToShow(tableId));

  }
}
