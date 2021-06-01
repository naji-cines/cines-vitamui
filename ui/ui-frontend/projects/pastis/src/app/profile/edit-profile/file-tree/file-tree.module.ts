/*
Copyright © CINES - Centre Informatique National pour l'Enseignement Supérieur (2020)

[dad@cines.fr]

This software is a computer program whose purpose is to provide
a web application to create, edit, import and export archive
profiles based on the french SEDA standard
(https://redirect.francearchives.fr/seda/).


This software is governed by the CeCILL-C  license under French law and
abiding by the rules of distribution of free software.  You can  use,
modify and/ or redistribute the software under the terms of the CeCILL-C
license as circulated by CEA, CNRS and INRIA at the following URL
"http://www.cecill.info".

As a counterpart to the access to the source code and  rights to copy,
modify and redistribute granted by the license, users are provided only
with a limited warranty  and the software's author,  the holder of the
economic rights,  and the successive licensors  have only  limited
liability.

In this respect, the user's attention is drawn to the risks associated
with loading,  using,  modifying and/or developing or reproducing the
software by the user in light of its specific status of free software,
that may mean  that it is complicated to manipulate,  and  that  also
therefore means  that it is reserved for developers  and  experienced
professionals having in-depth computer knowledge. Users are therefore
encouraged to load and test the software's suitability as regards their
requirements in conditions enabling the security of their systems and/or
data to be ensured and,  more generally, to use and operate it in the
same conditions as regards security.

The fact that you are presently reading this means that you have had
knowledge of the CeCILL-C license and that you accept its terms.
*/
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule,ReactiveFormsModule} from '@angular/forms';
import { SharedModule } from '../../../shared/shared.module';
import { UserActionsModule } from '../../../user-actions/user-actions.module';
import { DpDatePickerModule } from 'ng2-date-picker';

import { MatTableModule} from '@angular/material/table';
import { PastisMaterialModule } from '../../../material.module'

import { MAT_RIPPLE_GLOBAL_OPTIONS} from '@angular/material/core';


import { FileTreeMetadataComponent } from '../file-tree-metadata/file-tree-metadata.component';
import { FileTreeComponent } from './file-tree.component';
import { FiletreeFilterPipe } from './pipes/file-tree-filter.pipe';
import { AttributesPopupComponent } from '../file-tree-metadata/attributes/attributes.component';
import { PastisDialogConfirmComponent } from '../../../shared/pastis-dialog/pastis-dialog-confirm/pastis-dialog-confirm.component';
import { CoreModule } from 'projects/pastis/src/app/core';
import {EditableFieldModule} from "ui-frontend-common";

@NgModule({
    imports: [
        CommonModule,
        PastisMaterialModule,
        FormsModule,
        CoreModule,
        ReactiveFormsModule,
        MatTableModule,
        SharedModule,
        UserActionsModule,
        DpDatePickerModule,
        EditableFieldModule
    ],
  exports: [
    FileTreeComponent,
    FileTreeMetadataComponent
  ],
  providers:[{provide: MAT_RIPPLE_GLOBAL_OPTIONS, useValue: {disabled: true}}],
  declarations: [FileTreeMetadataComponent, FileTreeComponent,FiletreeFilterPipe,
    AttributesPopupComponent],
  entryComponents: [FileTreeComponent,FileTreeMetadataComponent,PastisDialogConfirmComponent,AttributesPopupComponent]
})

export class FileTreeModule {

}
