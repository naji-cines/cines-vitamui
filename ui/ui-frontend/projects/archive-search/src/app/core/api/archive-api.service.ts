/*
 * Copyright French Prime minister Office/SGMAP/DINSIC/Vitam Program (2019-2020)
 * and the signatories of the "VITAM - Accord du Contributeur" agreement.
 *
 * contact@programmevitam.fr
 *
 * This software is a computer program whose purpose is to implement
 * implement a digital archiving front-office system for the secure and
 * efficient high volumetry VITAM solution.
 *
 * This software is governed by the CeCILL-C license under French law and
 * abiding by the rules of distribution of free software.  You can  use,
 * modify and/ or redistribute the software under the terms of the CeCILL-C
 * license as circulated by CEA, CNRS and INRIA at the following URL
 * "http://www.cecill.info".
 *
 * As a counterpart to the access to the source code and  rights to copy,
 * modify and redistribute granted by the license, users are provided only
 * with a limited warranty  and the software's author,  the holder of the
 * economic rights,  and the successive licensors  have only  limited
 * liability.
 *
 * In this respect, the user's attention is drawn to the risks associated
 * with loading,  using,  modifying and/or developing or reproducing the
 * software by the user in light of its specific status of free software,
 * that may mean  that it is complicated to manipulate,  and  that  also
 * therefore means  that it is reserved for developers  and  experienced
 * professionals having in-depth computer knowledge. Users are therefore
 * encouraged to load and test the software's suitability as regards their
 * requirements in conditions enabling the security of their systems and/or
 * data to be ensured and,  more generally, to use and operate it in the
 * same conditions as regards security.
 *
 * The fact that you are presently reading this means that you have had
 * knowledge of the CeCILL-C license and that you accept its terms.
 */
import { Inject, Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { BASE_URL, BaseHttpClient, PageRequest, PaginatedResponse } from 'ui-frontend-common';
import { Observable } from 'rxjs';
import { tap } from 'rxjs/operators';
import {  SearchCriteriaDto } from '../../archive/models/search.criteria';
import { SearchResponse } from '../../archive/models/search-response.interface';



@Injectable({
  providedIn: 'root'
})
export class ArchiveApiService extends BaseHttpClient<any> {

  baseUrl: string;

  constructor(http: HttpClient, @Inject(BASE_URL) baseUrl: string) {
    super(http, baseUrl + '/archive-search');
    this.baseUrl = baseUrl;
  }

  getBaseUrl() {
    return this.baseUrl;
  }

  getAllPaginated(pageRequest: PageRequest, embedded?: string, headers?: HttpHeaders): Observable<PaginatedResponse<any>> {
    return super.getAllPaginated(pageRequest, embedded, headers).pipe(
      tap(result => result.values.map(ev => ev.parsedData = (ev.data != null) ? JSON.parse(ev.data) : null))
    );
  }

  getFilingHoldingScheme(headers?: HttpHeaders): Observable<SearchResponse> {
    return this.http.get<SearchResponse>(this.apiUrl + '/filingholdingscheme', { headers });
  }

  get(unitId: string, headers?: HttpHeaders): Observable<SearchResponse> {
    return this.http.get<any>(this.apiUrl + '/units/' + unitId, { headers });
  }

  searchArchiveUnitsByCriteria(criteriaDto: SearchCriteriaDto, headers?: HttpHeaders): Observable<SearchResponse> {
    return this.http.post<SearchResponse>( `${this.apiUrl}/search`, criteriaDto, {headers});
  }

  exportCsvSearchArchiveUnitsByCriteria(criteriaDto: SearchCriteriaDto, headers?: HttpHeaders): Observable<Blob> { 
  return  this.http.post(`${this.apiUrl}/export-csv-search`, criteriaDto, {
      responseType: 'blob',
      headers: headers
    });
  }


// Its a temporary api => to be removed when access contracts bill be delivered
  getAllAccessContracts(params: HttpParams, headers?: HttpHeaders): Observable<any[]> {
    return this.http.get<any>(`${this.apiUrl}/accesscontracts`, { params, headers });
  }

  downloadObjectFromUnit(id : string, headers?: HttpHeaders) : Observable<Blob> {
    return this.http.get(`${this.apiUrl}/downloadobjectfromunit/${id}`,{headers: headers, responseType: 'blob'});
  }

  findArchiveUnit(id: string, headers?: HttpHeaders) :Observable<any> {
      return this.http.get(`${this.apiUrl}/archiveunit/${id}`, { headers: headers, responseType: 'text' });
  }

}
