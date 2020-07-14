import { Injectable } from "@angular/core";
import { HttpClient } from "@angular/common/http";
import { Observable } from "rxjs";
import { DrugPayload, Drug } from "../models/drugs";
import { map } from "rxjs/operators";

@Injectable() 
export class DrugService{

    constructor(private httpClient: HttpClient){

    }

    private extractData(res: Response) {
        const body = res;
        return body || {};
       }

    getDrugs() : Observable<any>{
       return this.httpClient.post('https://bugzy/getDrugs', {}).pipe(map(this.extractData))
    }

    buyDrugs(drug: Drug[]) : Observable<any>{
        return this.httpClient.post('https://bugzy/buyDrugs', drug).pipe(map(this.extractData))
    }

    closeMenu(){
        return this.httpClient.post('https://bugzy/closeMenu', {}).pipe(map(this.extractData))
    }

}