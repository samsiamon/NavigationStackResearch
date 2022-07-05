//
//  RecipePreviewView.swift
//  NavStackTestApp
//
//  Created by Sam.Siamon on 7/5/22.
//

import SwiftUI

struct RecipePreviewView: View {
    @State var recipePreview: Recipe

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
            HStack {
                VStack{
                    Text(recipePreview.name)
                        .font(.title)
                        .fontWeight(.bold)
                    Text(recipePreview.description)
                        .font(.body)
                }
                .padding()
//                Image(systemName: "chevron.right")
//                    .padding()
            }
        }
        .frame(width: .infinity, height: 100)
    }
}

struct RecipePreviewView_Previews: PreviewProvider {
    static var previews: some View {
        RecipePreviewView(recipePreview: recipesList[0])
    }
}
