import { Injectable } from '@angular/core';
import {
  HttpRequest,
  HttpHandler,
  HttpEvent,
  HttpInterceptor,
  HttpResponse
} from '@angular/common/http';
import { Observable, of } from 'rxjs';
import { DrugPayload } from '../models/drugs';
@Injectable()
export class DrugInterceptor implements HttpInterceptor {
  constructor() {}
  intercept(request: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
    if(request.url.indexOf('getDrugs') > -1){
        let drugPayload : DrugPayload = {
            Drugs : [{
                Name : "Weed",
                DatabaseName: "d_cannabis",
                BuyQty: 0,
                Price: 500,
                SalePrice: 5000
            }]
        }
        return of(new HttpResponse({ status: 200, body:drugPayload }));
    }
   
    return next.handle(request);
  }
}