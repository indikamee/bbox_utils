/** Used for mapping csv-like collection into js table.
 * Each line will be passed as string[] */

export class ColumnDef {
    constructor(index, columnName, sourceFieldName, sourceIndex, formatFunction = (data) => data) {
      this.columnName = columnName;
      this.sourceFieldName = sourceFieldName;
      this.index = index;
      this.sourceIndex = sourceIndex;
      this.formatFunction = formatFunction;
    }

    formatData(data) {
        return this.formatFunction(data);
    }
};

// Assign source indexes by column header lookup.
export function indexify(colDefs, header) {
    colDefs.forEach(colDef => {
        const headerIndex = header.indexOf(colDef.sourceFieldName);
        if (headerIndex !== -1) {
            colDef.sourceIndex = headerIndex;
        } else {
            colDef.sourceIndex = null; // or any default value you prefer
        }
    });
}

export function formatToFloat2Dec(str) {
    const number = parseFloat(str);
    // Check if the parsed number is a valid float
    if (!isNaN(number)) {
        return number.toFixed(2);
    }
    // Return the original data or a default value if the conversion is not possible
    return str;
}

export function formatNumberAsIntegerWithCommas(numberString) {
    // Convert the string to a floating-point number
    const number = parseFloat(numberString);

    // Check if the conversion was successful
    if (isNaN(number)) {
      return "Invalid number"; // Or handle the error as appropriate
    }

    // Round the number to remove decimal places
    const roundedNumber = Math.round(number);

    // Convert the number back to a string with commas for thousands
    return roundedNumber.toLocaleString('en-US');
  }



export function formatDate(str) {
    return new Date(str).toISOString().split('T')[0]
}


export function storeTableRowsToShow(tableId){
    return function(e, settings, len) {
        localStorage.setItem(tableId+'-length', len)
    };
}

export function getTableRowsToShow(tableId) {
    return localStorage.getItem(tableId+'-length') || 10;
}

export function addFilters(table, columnIndexes) {
    table.columns(columnIndexes).every(function() {
        var column, select;
        column = this;
        select = $('<select><option value=""></option></select>').appendTo($(column.footer()).empty()).on('change', function() {
        var val;
        //console.log("Filtered........");
        val = $.fn.dataTable.util.escapeRegex($(this).val());
            column.search((val ? '^' + val + '$' : ''), true, false).draw();
        });
        Array.from(column.nodes())
        .map(node => node.getAttribute('data-search') || node.innerHTML)
        .filter((value, index, self) => self.indexOf(value) === index) // Unique
        .sort()
        .forEach(function (d) {
            select.append(`<option value="${d}">${d}</option>`);
        });
    });
    $('.dataTables_filter input,select').addClass('form-control');
};
