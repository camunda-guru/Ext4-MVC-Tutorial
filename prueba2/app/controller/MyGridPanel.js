/*
 * File: app/controller/MyGridPanel.js
 *
 * This file was generated by Sencha Designer version 2.0.0.
 * http://www.sencha.com/products/designer/
 *
 * This file requires use of the Ext JS 4.0.x library, under independent license.
 * License of Sencha Designer does not include license for Ext JS 4.0.x. For more
 * details see http://www.sencha.com/license or contact license@sencha.com.
 *
 * You should implement event handling and custom methods in this
 * class.
 */

Ext.define('DEMO.controller.MyGridPanel', {
    extend: 'Ext.app.Controller',
    refs: [
      {
        ref: 'background',
        selector: 'background'
      },
      {
        ref: 'mygridpanel',
        selector: 'mygridpanel'
      },
      {
        ref: 'mainview',
        selector: 'mainview'
      }
    ],

    views: ['CustomerDataForm'],
    models: ['Customer'],
    stores: ['MyJsonStore'],

    init: function() {
        me = this;
        this.control({
            "button[id=btnDelete]": {
                click: this.onDeleteClick
            },
            "button[id=btnEdit]": {
                click: this.onEditClick
            },
            "button[id=btnInsert]": {
                click: this.onInsertClick
            },
            "mainview": {
                render: this.onMainViewRender
            },

            "mygridpanel": {
                itemclick: this.onGridviewItemClick,
                selectionchange: this.onGridviewSelectionChange
            }
        });

    },

    onMainViewRender: function(){
        this.getMygridpanel().store.load();
   },

    onGridpanelRender: function(g, eopts){
        g.store.load();
    },

    onDeleteClick: function(button, e, options) {
        console.log('Delete click');
    },

    onEditClick: function(button, e, options) {
        // get selected record
        record =  button.up('gridpanel').getSelectionModel().getSelection()[0];
        // create controller passing record as parameter
        controller = this.getController('DEMO.controller.CustomerDataForm');
        controller.init(record);
        controller.onAfterSave = this.onAfterSave;
    },

    onInsertClick: function(button, e, options) {
        // create a new record
        record = Ext.create('DEMO.model.Customer', {});
        record.data.Id = -1;
        // create controller passing record as parameter
        controller = this.getController('DEMO.controller.CustomerDataForm');
        controller.init(record);
        controller.onAfterSave = this.onAfterSave;
    },

    onAfterSave: function(){
      this.getMyJsonStoreStore().load();
    },

    onGridviewItemClick: function(dataview, record, item, index, e, options) {
        console.log('GridViewClick');
        console.log(record.data.Name);
    },

    onGridviewSelectionChange: function(model, selections, options) {
        console.log('Selection change');
        if(!model.hasSelection()){
            Ext.getCmp('btnDelete').disable();
            Ext.getCmp('btnEdit').disable();
            console.log('disabled');
        }
        else
        {
            Ext.getCmp('btnDelete').enable();
            Ext.getCmp('btnEdit').enable();
            console.log('enabled');
        };
    }


});
