import { Component, OnInit } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { map } from 'rxjs/operators'
import { DrugPayload, Drug } from '../models/drugs';
import { DrugService } from '../services/drug.service';

@Component({
    selector: 'app-drug-shop',
    templateUrl: './drug-shop.component.html'
})
export class DrugShopComponent implements OnInit {
    title = 'DrugBuying';
    public drugs: Array<Drug>;
    public showMenu = false;
    displayedColumns: string[] = ['Name', 'Price', "Action"];
    basketColumns: string[] = ['Name', "Qty", "TotalPrice"];

    constructor(private drugService: DrugService) {

        window.addEventListener('message', (event) => {
            if (event.data.type === 'open') {
                this.showMenu = true;
            }
            if (event.data.type === 'close') {
               this.showMenu = false;
            }
        });
    }

    isNumberKey(event){
        let charCode = (event.which) ? event.which : event.keyCode;
        if (charCode > 31 && (charCode < 48 || charCode > 57)){
           return false;
        }
        return true;
     }

    ngOnInit() {
        this.drugService.getDrugs().subscribe((data) => {
            this.drugs = data.Drugs
        })
    }

    drugQtyUpdated(event,drug:Drug){
        drug.BuyQty = event.target.value;
    }

    addDrug(drug: Drug, qty: number) {
        drug.BuyQty += qty;
    }

    remove(drug: Drug, qty: number) {
        drug.BuyQty -= qty;
        if (drug.BuyQty < 0) {
            drug.BuyQty = 0;
        }
    }

    addFive(drug: Drug) {
        drug.BuyQty += 5;
    }

    close() {
        this.drugService.closeMenu().subscribe((data) => {

        })
    }

    buyDrug() {
        console.log(this.drugs);
        this.drugService.buyDrugs(this.getbasketDetails()).subscribe((data) => {
            console.log("Data from server : " + JSON.stringify(data))
            if(data.event){
                this.drugs.forEach(element => {
                    element.BuyQty = 0;
                });
            }
        })
    }

    getbasketDetails(): Array<Drug> {
        return this.drugs.filter(x => x.BuyQty > 0);
    }


}
