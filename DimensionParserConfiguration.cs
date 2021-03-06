// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

using System.Globalization;

namespace Microsoft.Recognizers.Text.NumberWithUnit.Turkish
{
    public class DimensionParserConfiguration : TurkishNumberWithUnitParserConfiguration
    {
        public DimensionParserConfiguration()
               : this(new CultureInfo(Culture.Turkish))
        {
        }

        public DimensionParserConfiguration(CultureInfo ci)
               : base(ci)
        {
            this.BindDictionary(DimensionExtractorConfiguration.DimensionSuffixList);
        }
    }
}
