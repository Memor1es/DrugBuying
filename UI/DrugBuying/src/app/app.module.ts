import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { DrugShopComponent } from './DrugShop/drug-shop.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { HttpClientModule, HTTP_INTERCEPTORS } from '@angular/common/http';
import { DrugService } from './services/drug.service';
import { DrugInterceptor } from './services/test.httpinteceptor';

const routes: Routes = [
  { path: '', component: DrugShopComponent }
];

@NgModule({
  declarations: [
    AppComponent,
    DrugShopComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    RouterModule.forRoot(routes),
    BrowserAnimationsModule,
    HttpClientModule,
  ],
  providers: [DrugService, {
    provide: HTTP_INTERCEPTORS,
    useClass: DrugInterceptor,
    multi: true
  }],
  bootstrap: [AppComponent]
})
export class AppModule { }
